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
    @group = Group.new(group_params)
    @group.add(current_user, as: 'owner')
    if @group.save
      flash[:success] = "Group created!"
      redirect_to groups_path
    else
      render action: :new
    end
  end
  
  def show
    @group = Group.find( params[:id] )
    @users = User.in_group(@group)
    @owner = @group.users.as('owner')
  end
  
  def update
    @group = Group.find( params[:id] )
    @user = current_user
    
    #Check it user is already in group
    #if !@group.users.find(@user)
    @group.add(@user)
    #If user is not in group return error
    #end
  end
  
  private
    def group_params
      params.require(:group).permit(:type, :name)
    end

end
