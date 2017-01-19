class OrganizationsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :user
  before_action :can_create_organization?, only: :new
  
  def index
    #@organizations=Organization.where.not(owner_id: 0)
  end
    
  def new
    @organization=Organization.new
  end
  
  def create
    @organization=Organization.new(organization_params)
    @organization.owner_id=current_user.id
    if @organization.save
      flash[:success] = "Organization created!"
      redirect_to organizations_path
    else
      render action: :new
    end
  end
  
  def show
    @organization = Organization.find( params[:id] )
    @groups = @org.groups
    @owner = User.find_by(id: @org.owner_id)
  end
  
  def update
    # add more groups to organization here
  end
  
  private
    def organization_params
      params.require(:organization).permit(:name)
    end
    
    def over_organization_creation_limit?
      num_groups=Organization.find_roles(:organization_creator, current_user).count
      return !(num_groups<1)
    end
    
    def can_create_organization?
      if current_user.plan_id==3
        if over_organization_creation_limit?
          flash[:notice] = 'You have reached your organization creation limit!'
          redirect_to(root_url)
        end
      else
        flash[:notice] = 'Upgrade plan to create an organization!'
        redirect_to(plans_path)
      end
    end
end
