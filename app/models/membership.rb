class Membership < ApplicationRecord
  belongs_to :group #, inverse_of: :membership
  belongs_to :user #, inverse_of: :membership
  
  #this table has a flag called owner and thus a method called owner??
  def owner?
  end
end
