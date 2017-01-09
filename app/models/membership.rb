class Membership < ApplicationRecord
  belongs_to :group
  belongs_to :user
  
  #this table has a flag called owner and thus a method called owner??
  def owner?
  end
end
