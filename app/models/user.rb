class User < ApplicationRecord
  rolify
  after_create :assign_default_role
  belongs_to :plan
  has_one :profile
  
  has_many :memberships
  has_many :groups, through: :memberships

  #has_many :animals
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
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
  
  def assign_default_role
    self.add_role(:newuser) if self.roles.blank?
  end
  
end
