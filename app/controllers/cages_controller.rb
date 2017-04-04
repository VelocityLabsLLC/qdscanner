class CagesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :group
  load_and_authorize_resource :cage, :find_by => :cage_id, :through => :group, :shallow => true

  skip_authorize_resource :cage, :only => [:show, :edit, :update]
  
  def index
    #@group = Group.find( params[:group_id] )
    #@cages = @group.cages
  end
  
  def new
    # @cage = Cage.new
    # @group = Group.find(params[:group_id])
  end
  
  def create
    @cage = Cage.new(cage_params)
    authorize! :update, @cage, :through => :group
    if @cage.save
      current_user.add_role("owner", @cage)
      flash[:success] = "Cage added!"
      redirect_to group_cages_path(group_id: params[:group_id])
    else
      flash[:danger]="Error please try again"
      render action: :new
    end
  end
  
  def show
    @cage = Cage.find(params[:cage_id])
    authorize! :show, @cage, :through => :group
    @animals = @cage.animals
  end

  def edit
    @cage = Cage.find(params[:cage_id])
    authorize! :update, @cage, :through => :group
  end
  
  def update
    @cage = Cage.find(params[:cage_id])
    authorize! :update, @cage, :through => :group
    if @cage.update_attributes(cage_params)
      flash[:success] = "Cage info updated!"
      # Redirect user to cage path
      redirect_to group_cage_path(group_id: params[:group_id], cage_id: params[:cage_id] )
    else
      render action: :edit
    end
  end
  
  def destroy
    @cage = Cage.find(params[:cage_id])
    @cage.destroy
    redirect_back fallback_location: group_cages_path(params[:group_id])
  end
  
  private
    def cage_params
      params.require(:cage).permit(:cage_number,
                                    :pi,
                                    :protocol,
                                    :requisition,
                                    :cost_center,
                                    :age_or_weight,
                                    :species,
                                    :s_s_b,
                                    :receive_date,
                                    :transfer_date,
                                    :birth_date,
                                    :gender,
                                    :total_animals,
                                    :location,
                                    :vendor,
                                    :emergency_num,
                                    :comment,
                                    :group_id,
                                    :user_id)
    end
end
