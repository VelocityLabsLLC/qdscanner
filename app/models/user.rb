class User < ApplicationRecord
  belongs_to :plan
  has_one :profile
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  #Groupify  model 
  groupify :group_member
  groupify :named_group_member
  
  # Invitations:
  has_many :invitations, :class_name => "Invite", :foreign_key => 'recipient_id'
  has_many :sent_invites, :class_name => "Invite", :foreign_key => 'sender_id'

  attr_accessor :stripe_card_token
  # IF Pro user passes validations (email, password, etc.),
  # then call Stripe and tell Stripe to set up a subscription
  # upon charging the customer's card.
  # Stripe responds back with customer data.
  # Store customer.id as the customer token and save the user.
  def save_with_subscription
    if valid?
      customer = Stripe::Customer.create(description: email, plan: plan_id, card: stripe_card_token)
      self.stripe_customer_token = customer.id
      save!
    end
  end
  
end
