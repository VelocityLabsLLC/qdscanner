class AnimalsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :group
  load_and_authorize_resource :animal, :through => :group, :shallow => true
  
  def index
    @group = Group.find( params[:group_id] )
    @animals = @group.animals
  end
  
  def new
    # @animal = Animal.new
    # @group = Group.find(params[:group_id])
  end
  
  def create
    puts "------------------------------------------------------------------------------------------------"
    puts "CanCan Group id: #{@group.id}"
    puts "Html group_id: #{params[:group_id]}"
    puts "Animal params group_id: #{params[:animal][:animal_type]}"
    
    puts "Animal_params: #{params[:animal]}"
    
    @animal = Animal.new(animal_params)
    if @animal.save
      puts "Animal saved in group_id: #{animal_params[:group_id]}"
      puts "--------------------------------------------------------------------------------------------------------"
      current_user.add_role("owner", @animal)
      flash[:success] = "Animal added!"
      redirect_to group_animals_path(group_id: params[:group_id])
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
      redirect_to group_animal_path(group_id: params[:group_id], animal_id: params[:animal_id] )
    else
      render action: :edit
    end
  end
  
  def destroy
    @animal = Animal.find(params[:animal_id])
    @animal.destroy
    redirect_back fallback_location: group_animals_path(params[:group_id])
  end
  
  private
    def animal_params
      params.require(:animal).permit(:animal_type, :strain, :location, :status, :group_id, :user_id)
    end
  
end
