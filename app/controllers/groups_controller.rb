class GroupsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :can_create_group?, only: :new
  
  def index
    # if current_user.organization
    #   @groups = current_user.organization.groups
    # else
    #   @groups = Organization.find(1).groups
    # end
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
      redirect_to group_path(id: @group.id)
    else
      flash[:success] = "Failed to create group!"
      render action: :new
    end
  end
  
  def show
    @users = @group.users
    @owner = User.find_by(id: @group.owner_id)
  end

  def update
    # Add users to group??
  end
  
  def destroy
    # Delete group
  end
  
  # Add a user to the group
  def add_user
    # add users to group
    @user = User.find ( params[:user_id] )
    # Check if user is already a member of the group
    unless @user.groups.exists?( params[:id] )
      # Shovel group into users to add a Membership record reference
      @user.groups << @group
      # Check if Membership record exists now
      if @group.users.exists?( @user.id )
        flash[:success] = "Group added!"
        @user.add_role(:default_role, @group )
        # Redirect user group page
        redirect_to group_path(id: params[:id] )
      else
        flash[:danger] = "Failed to add group please try again!"
        render group_path(id: params[:id] )
      end
    else
      flash[:danger] = "You already belong to this group!"
      # Redirect user to group page
      redirect_to group_path( id: params[:id] )
    end
  end
  
  # Remove a user from the group
  def remove_user
    @user = User.find( params[:user_id] )
    # Check if user is a creator or admin
    # Place holder has to be there for query to work
    if @user.has_any_role? :place_holder , { :name => :creator, :resource => @group }, { :name => :admin, :resource => @group }
      puts "User is an admin"
      # user is an admin
      # Check if there are other admins
      if only_admin?
        puts "User is the only admin in group"
        # If there are no other admins redirect to organization page and flash error
        flash[:danger] = "Please add another admin to the organization before you leave!"
        return redirect_to group_path(@group.id)
      else
        puts "User is not the only admin in org"
      end
    end
    # There is an alternate admin if method did not return yet
    # Proceed with deleting Membership association and instance roles
    @group.users.delete(@user)
    remove_instance_roles
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
        if current_user.has_role? :group_creator
          if over_group_creation_limit?
            flash[:notice] = 'You have reached the group creation limit set by your organization!'
            redirect_to(root_url)
          end
        else
          if current_user.organizations
            flash[:notice] = 'You do not have access to group creation in this organization!'
            redirect_to(plans_path)
          else
            flash[:notice] = 'You must upgrade plan to create more groups!'
            redirect_to(plans_path)
          end
        end
      elsif current_user.plan_id==2
        if over_group_creation_limit?
          flash[:notice] = 'You have reached your group creation limit, upgrade plan to create more groups!'
          redirect_to(plans_path)
        end
      else
        if over_group_creation_limit?
          flash[:notice] = 'You have reached your group creation limit, upgrade plan to create more groups!'
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
