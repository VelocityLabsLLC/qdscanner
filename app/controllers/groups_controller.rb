class GroupsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :can_create_group?, only: :new
  
  def index
    @groups = Group.all
  end
  
  def new
    @group = Group.new
  end
  
  # POST to /groups
  def create
    org_id=Organization.find_by(name: params[:group][:organization]).id
    @group = Group.new
    @group.name = params[:group][:name]
    @group.description = params[:group][:description]
    @group.organization_id = org_id
    @group.owner_id=current_user.id
    # May have to manually add the membership has_many :through relationship
    # @group.memberships.create(:user => current_user)
    if @group.save
      current_user.add_role("admin", @group)
      current_user.add_role("creator", @group)
      flash[:success] = "Group created!"
      redirect_to group_path
    else
      render action: :new
    end
  end
  
  def show
    @group = Group.find( params[:id] )
    @users = @group.users
    @owner = User.find_by(id: @group.owner_id)
  end
  
  def update
    @group = Group.find( params[:id] )
    @user = current_user
    
    #Check it user is already in group
    #if !@group.users.find(@user)
    @user.groups << @group
    #If user is already in group return error
    #end
  end
  
  private
    def group_params
      params.require(:group).permit(:name, :description, :organization)
    end
    
    def over_group_creation_limit?
      num_groups=Group.find_roles(:group_creator, current_user).count
      return !(num_groups<current_user.group_creation_limit)
    end
    
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
end
