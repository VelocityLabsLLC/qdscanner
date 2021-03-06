class AnimalsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :group
  load_and_authorize_resource :cage, :through => :group, :shallow => true
  load_and_authorize_resource :animal, :through => :cage, :shallow => true
  
  def index
    @group = Group.find( params[:group_id] )
    @animals = @group.animals
  end
  
  def new
    @group = Group.find(params[:group_id])
    @cage = Cage.find(params[:cage_id])
    # authorize! :group
    # authorize! :cage
    @animal = Animal.new
  end
  
  def create
    @animal = Animal.new(animal_params)
    if @animal.save
      current_user.add_role("owner", @animal)
      flash[:success] = "Animal added!"
      redirect_to group_cage_animals_path(group_id: params[:group_id], cage_id: @animal.cage_id)
    else
      flash[:danger]="Error please try again"
      render action: :new
    end
  end
  
  def show
    @animal = Animal.find(params[:animal_id])
  end

  def edit
    @animal = Animal.find(params[:animal_id])
    @group = Group.find(params[:group_id])
  end
  
  def update
    @animal = Animal.find(params[:animal_id])
    if @animal.update_attributes(animal_params)
      flash[:success] = "Animal info updated!"
      # Redirect user to their profile page
      redirect_to group_cage_animal_path(group_id: params[:group_id], cage_id: @animal.cage_id, animal_id: params[:animal_id] )
    else
      render action: :edit
    end
  end
  
  def destroy
    @animal = Animal.find(params[:animal_id])
    @animal.destroy
    redirect_back fallback_location: group_cage_animals_path(params[:group_id])
  end
  
    
  
  
  private
    def animal_params
      params.require(:animal).permit(:identifier, :species, :strain, :status, :user_id, :cage_id)
    end
  
end
