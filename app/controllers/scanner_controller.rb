class ScannerController < ApplicationController
  def index
    @cages=Cage.all
  end
end
