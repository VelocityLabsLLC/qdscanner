class ScannerController < ApplicationController
  def index
    @cages=Cage.all
  end
  
  def check_cage_exists
    scanned_number = params[:scanned_number]
    puts "========================================="
    puts "params[:cage_number]"
    puts params[:scanned_number]
    puts "scanned_number:"
    puts scanned_number
    puts "============================================"
    @cage=Cage.find_by cage_number: scanned_number
    
    if @cage
      render json: @cage
    else
      render json: Cage.new(cage_number: scanned_number)
    end
    
  end
  
  private
    def scanner_params
      params.require(:scanner).permit(:scanned_number)
    end
    
end
