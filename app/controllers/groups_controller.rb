class GroupsController < ApplicationController
  before_action :authenticate_user!
  
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

end
