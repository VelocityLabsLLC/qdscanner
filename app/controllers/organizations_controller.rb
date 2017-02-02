class OrganizationsController < ApplicationController
  before_action :authenticate_user!
  #load @organization/s and authorize user for all actions
  load_and_authorize_resource
  before_action :can_create_organization?, only: :new
  
  def index
    # load
    #@organizations=Organization.where.not(owner_id: 0)
  end
    
  def new
    #@organization=Organization.new
  end
  
  def create
    @organization=Organization.new(organization_params)
    @organization.owner_id=current_user.id
    if @organization.save
      current_user.update(organization_id: @organization.id)
      current_user.add_role(:creator, @organization)
      flash[:success] = "Organization created!"
      redirect_to organizations_path
    else
      render action: :new
    end
  end
  
  def show
    @organization = Organization.find( params[:organization_id] )
    @groups = @organization.groups
    @owner = User.find(@organization.owner_id)
  end
  
  def update
    # Add groups to organization
  end
  
  def destroy
    # Delete organization
  end
  
  def add_user
    # add users to organization
    @organization=Organization.find( params[:organization_id] )
    @user = User.find ( params[:user_id] )
    if @user.organization_id==1
      if @user.update(organization_id: params[:organization_id])
        flash[:success] = "Organization added!"
        @user.add_role(:default_role, @organization )
        # Redirect user organization page
        redirect_to organization_path(organization_id: params[:organization_id] )
      else
        flash[:danger] = "Failed to add organization please try again!"
        render organization_path(organization_id: params[:organization_id] )
      end
    else
      flash[:danger] = "You already belong to an organization!"
      # Redirect user to their profile page
      redirect_to organization_path(organization_id: @user.organization_id )
    end
  end
  
  def remove_user
    # Place holder has to be there for query to work
    @user = User.find( params[:user_id] )
    if @user.has_any_role? :place_holder , { :name => :creator, :resource => @organization }, { :name => :admin, :resource => @organization }
      puts "User is an admin"
      # user is an admin
      # Check if there are other admins
      if only_admin?
        puts "User is the only admin in org"
        # If there are no other admins redirect to organization page and flash error
        flash[:danger] = "Please add another admin to the organization before you leave!"
        return redirect_to organization_path(@organization.id)
      else
        puts "User is not the only admin in org"
      end
    end
    # There is an alternate admin if method did not return yet
    @organization.users.delete(@user)
    remove_instance_roles
  end
  
  private
    def organization_params
      params.require(:organization).permit(:name)
    end
    
    def over_organization_creation_limit?
      num_groups=Organization.find_roles(:creator, current_user).count
      return !(num_groups<1)
    end
    
    def can_create_organization?
      if current_user.plan_id==3
        if over_organization_creation_limit?
          flash[:notice] = 'You have reached your organization creation limit!'
          return redirect_to(root_url)
        end
      else
        flash[:notice] = 'Upgrade plan to create an organization!'
        #redirect_to(plans_path)
      end
    end
    
    # Check if user is the only admin
    def only_admin?
      admins=User.with_role(:creator, @organization) + User.with_role(:admin, @organization)
      return admins.reject { |key| key.id==@user.id }.empty?
    end
    
    # Remove all roles associated with group instance
    def remove_instance_roles
      rol_list = ["creator", "admin", "default_role"]
      rol_list.each do |rol|
        if @user.has_role?(rol, @organization) then @user.remove_role(rol, @organization) end
      end
    end
end
