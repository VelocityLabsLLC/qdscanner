class OrganizationsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @orgs=Organization.where.not(owner_id: 0)
  end
    
  def new
    @org=Organization.new
  end
  
  def create
    @org=Organization.new(organization_params)
    @org.owner_id=current_user.id
    if @org.save
      flash[:success] = "Organization created!"
      redirect_to organizations_path
    else
      render action: :new
    end
  end
  
  def show
    @org = Organization.find( params[:id] )
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
end
