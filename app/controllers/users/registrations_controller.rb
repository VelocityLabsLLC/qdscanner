class Users::RegistrationsController < Devise::RegistrationsController
  before_action :select_plan, only: :new

  # Extend default Devise gem behavior so that users signing up with 
  # the Premium or Pro account (plan ID 2 or 3) save with a special Stripe subscription function
  # Otherwise Devise signs up user as usual
  def create
    super do |resource|
      if params[:plan]
        resource.plan_id = params[:plan]
        if resource.plan_id == 3
          resource.group_creation_limit=100
          resource.add_role :organization_creator
          resource.add_role :group_creator
          resource.save_with_subscription
        elsif resource.plan_id == 2
          resource.add_role :group_creator
          resource.group_creation_limit=1
          resource.organization = Organization.first
          resource.save_with_subscription
        else
          resource.add_role :basic
          resource.group_creation_limit=0
          resource.save
        end
      end
    end
  end
  
  def update_cc
       
  end
  
  private
    def select_plan
      unless (params[:plan] == '1' || params[:plan] == '2' || params[:plan] == '3')
        flash[:notice] = "Please select a membership plan to sign up."
        redirect_to root_url
      end
    end
end