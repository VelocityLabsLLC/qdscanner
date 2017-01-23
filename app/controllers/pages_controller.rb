class PagesController < ApplicationController
  def home
    @basic_plan = Plan.find(1)
    @premium_plan = Plan.find(2)
    @pro_plan = Plan.find(3)
  end
  
  def about
  end
  def plans
    @basic_plan = Plan.find(1)
    @premium_plan = Plan.find(2)
    @pro_plan = Plan.find(3)
  end
end