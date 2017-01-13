class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_can_create_group, only: :new
  
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
    
    if @group.save
      if current_user.plan_id==2
        current_user.remove_role("group_creator")
      end
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
    
    def check_create_group_limit
      group_limit=1
      num_groups=Group.find_roles(:group_creator, user).count
      return num_groups<group_limit
    end
    
    def check_can_create_group
      if current_user.plan_id==1
        unless current_user.has_role? :group_creator
          flash[:notice] = 'You must upgrade plan to create more groups!'
          redirect_to(plans_path)
        end
      elsif current_user.plan_id==2
        unless check_create_group_limit
          flash[:notice] = 'You have reached your group creation limit, upgrade plan to create more groups!'
        redirect_to(plans_path)
        end
      end
    end
end
