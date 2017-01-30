class UsersController < ApplicationController
  
  def index
    @users = User.includes(:profile)
  end
  
  # GET to /users/:user_id
  def show
    @user = User.find( params[:user_id] )
  end
  
  def edit_payment
    @user = User.find( params[:user_id] )
    if @user.stripe_customer_token
      customer = Stripe::Customer.retrieve(@user.stripe_customer_token)
      @cards = customer.sources.all(:object => "card")
      @default_card=customer.default_source
    end
    @subscription = customer.subscriptions.first
    #@current_plan=subscription.plan.id
    #subscription.plan = "premium_monthly"
    #subscription.save
  end
  
  def update_payment
    @user = User.find( params[:user_id] )
    customer = Stripe::Customer.retrieve(@user.stripe_customer_token)
    @cards = customer.sources.all(:object => "card")
    # If a new stripe card token was created add it to the list
    if params[:user][:stripe_card_token]!="none"
      # Add new card to customer
      card = customer.sources.create(source: params[:user][:stripe_card_token])
      puts card
      # Select the card id and make it the default card
      customer.default_source = card.id
    else
      # If a new token was not created, then we are just changing the default card
      customer.default_source = params[:card_id]
    end
    
    # If plan_id was passed, then user wants to change plans
    if params[:plan_id]
      # Verify that the plan is different from the current plan
      if params[:plan_id].to_i!=@user.plan_id
        # Save stripe subscription
        subscription=customer.subscriptions.first
        subscription.plan=params[:plan_id]
        subscription.save
        
        # Enable/Disable new roles new plan can only be 2 or 3,
        # otherwise the subscription would have been deleted
        if params[:plan_id].to_i==2 # Change to 2 from 3
          @user.roles = nil
          @user.add_role(:group_creator)
          if user.organization
            organization = user.organization
            organization.users.delete(@user)
          end
        else
          @user.add_role(:organization_creator)
        end
        @user.plan_id=params[:plan_id].to_i
        @user.save
      else
        flash[:danger]="You are already subscribed to #{Plan.find(params[:plan_id]).name} plan"
      end
    end
    
    # Save customer update to Stripe
    if customer.save
      flash[:success]="Your information was changed!"
      redirect_to edit_user_registration_path
    else  
      flash[:danger]="Something went wrong please try again"
      redirect_to user_edit_payment_path(:user_id => @user.id)
    end
  end
  
  def delete_card
    @user = User.find( params[:user_id] )
    customer = Stripe::Customer.retrieve(@user.stripe_customer_token)
    customer.sources.retrieve(params[:card_id]).delete()
    redirect_to user_edit_payment_path(:user_id => @user.id)
  end
  
  def cancel_subscription
    @user = User.find( params[:user_id] )
    customer = Stripe::Customer.retrieve(@user.stripe_customer_token)
    subscription = customer.subscriptions.first
    subscription.delete
  end
  
  private
    def card_params
      params.require(:user).permit(:stripe_card_token, :card_id)
    end
    
end