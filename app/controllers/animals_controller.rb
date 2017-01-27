class AnimalsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  
  def index
    @group=Group.find(params[:id])
  end
  
  def new
  end
  
  def create
  end
  
  def show
  end

  def edit
  end
  
  def update
  end
  
  def delete
  end
  
  private
    def animal_params
      params.require(:animal).permit(:animal_type, :strain, :location, :status, :group_id, :user_id)
    end
  
end
