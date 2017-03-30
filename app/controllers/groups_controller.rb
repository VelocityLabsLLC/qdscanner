class GroupsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :can_create_group?, only: :new
  
  def index
    @groups=current_user.organization.groups
  end
  
  def new
    @organizations=Organization.all
  end
  
  # POST to /groups
  def create
    @user = User.find( params[:group][:owner_id] )
    # Create group through Membership association with create()
    @group = @user.groups.create(group_params)
    if @group.save
      @user.add_role("creator", @group)
      flash[:success] = "Group created!"
      redirect_to group_path(group_id: @group.id)
    else
      flash[:danger] = "Failed to create group!"
      render action: :new
    end
  end
  
  def show
    @group = Group.find(params[:group_id])
    @users = @group.users
    @owner = User.find(@group.owner_id)
    @cages = @group.cages
    @animals = @group.animals
  end

  def update
    # Add users to group??
  end
  
  def destroy
    # Delete group
  end
  
  # Add a user to the group
  def add_user
    # Grab user and group
    @user = User.find ( params[:user_id] )
    @group = Group.find ( params[:group_id] )
    # Check if user is already a member of the group
    unless @user.groups.exists?( @group )
      # Shovel group into users to add a Membership record reference
      @user.groups << @group
      # Check if Membership record exists now
      if @group.users.exists?( @user.id )
        flash[:success] = "Group added!"
        @user.add_role(:default_role, @group )
        # Redirect user group page
        redirect_to group_path( group_id: params[:group_id] )
      else
        flash[:danger] = "Failed to add group please try again!"
        render group_path( group_id: params[:group_id] )
      end
    else
      flash[:danger] = "You already belong to this group!"
      # Redirect user to group page
      redirect_to group_path( group_id: params[:group_id] )
    end
  end
  
  # Remove a user from the group
  def remove_user
    @user = User.find( params[:user_id] )
    @group = Group.find(params[:group_id] )
    
    # If removing self skip this check
    unless @user=current_user
      # If removing another, is the current user authorized?
      unless can?(:update, @group)
        flash[:danger] = "Not authorized to remove other users"
        return redirect_to group_path( group_id: params[:group_id] )
      end
    end
    # Check if user is a creator or admin
    # Place holder has to be there for query to work
    if @user.has_any_role? :place_holder , { :name => :creator, :resource => @group }, { :name => :admin, :resource => @group }
      puts "User is an admin"
      # user is an admin
      # Check if there are other admins
      if only_admin?
        puts "User is the only admin in group"
        # If there are no other admins redirect to organization page and flash error
        flash[:danger] = "Please add another admin to the group before you leave!"
        return redirect_to group_path( group_id: params[:group_id] )
      else
        puts "User is not the only admin in org"
      end
    end
    # There is an alternate admin if method did not return yet
    # Proceed with deleting Membership association and instance roles
    @group.users.delete(@user)
    remove_instance_roles
    if current_user==@user
      flash[:success] = "You have left the group!"
    else
      flash[:success] = "User have been removed from the group!"
    end
    redirect_to group_path( group_id: params[:group_id] )
  end
  
  def scanner
    # React.js Cage Barcode Scanner
    @group = Group.find(params[:group_id])
    @cages = @group.cages
    @animals = @group.animals
  end
  
  private
    def group_params
      params.require(:group).permit(:name, :description, :owner_id, :organization_id)
    end
    
    def over_group_creation_limit?
      num_groups=Group.find_roles(:creator, current_user).count
      return !(num_groups<current_user.group_creation_limit)
    end
    
    # Check if the user can create groups
    def can_create_group?
      if current_user.plan_id==1
        if can?(:create, Group)
          if over_group_creation_limit?
            flash[:danger] = 'You have reached the group creation limit set by your organization!'
            redirect_to(root_url)
          end
        else
          unless current_user.organization==1
            flash[:danger] = 'You do not have access to group creation in this organization!'
            redirect_to(plans_path)
          else
            flash[:danger] = 'You must upgrade plan to create more groups!'
            redirect_to(plans_path)
          end
        end
      elsif current_user.plan_id==2
        if over_group_creation_limit?
          flash[:danger] = 'You have reached your group creation limit, upgrade plan to create more groups!'
          redirect_to(plans_path)
        end
      else
        if over_group_creation_limit?
          flash[:danger] = 'You have reached your group creation limit, upgrade plan to create more groups!'
          redirect_to(plans_path)
        end
      end
    end
    
    # Check if the user is the only admin left in the group
    def only_admin?
      admins=User.with_role(:creator, @group) + User.with_role(:admin, @group)
      return admins.reject { |key| key.id==@user.id }.empty?
    end
    
    # Remove all roles associated with group instance
    def remove_instance_roles
      rol_list = ["creator", "admin", "default_role"]
      rol_list.each do |rol|
        if @user.has_role?(rol, @group) then @user.remove_role(rol, @group) end
      end
    end
end
