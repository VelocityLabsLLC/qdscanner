class Users::RegistrationsController < Devise::RegistrationsController
  before_action :select_plan, only: :new
  #before_save :check_user_existence
  
  # Extend default Devise gem behavior so that users signing up with 
  # the Pro account (plan ID 2) save with a special Stripe subscription function
  # Otherwise Devise signs up user as usual
  #def new
  #  @token = params[:invite_token] #<-- pulls the value from the url query string
  #end
  def create
    super do |resource|
      if params[:plan]
        resource.plan_id = params[:plan]
        if resource.plan_id == 2
          resource.save_with_subscription
        else
          resource.save
        end
      end
      #@token = params[:invite_token]
      #if @token != nil
      #  org =  Invite.find_by_token(@token).user_group #find the user group attached to the invite
      #  @newUser.user_groups.push(org) #add this user to the new user group as a member
      #else
      #  # do normal registration things #
      #end
    end
  end
  private
    def select_plan
      unless (params[:plan] == '1' || params[:plan] == '2')
        flash[:notice] = "Please select a membership plan to sign up."
        redirect_to root_url
      end
    end

  #def check_user_existence
  #  recipient = User.find_by_email(email)
  #  if recipient
  #    self.recipient_id = recipient.id
  #  end
  #end
end