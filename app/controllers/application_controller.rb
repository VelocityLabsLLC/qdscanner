class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  # Whitelist the following form fields so that we can process them, if coming
  # from a devise signup form
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  # Cancancan with Devise wiki. This will redirect for unauthorized error
  
  # check_authorization :unless => :devise_controller?
  
  # rescue_from CanCan::Unauthorized do |exception|
  #   if current_user.nil?
  #     session[:next] = request.fullpath
  #     puts session[:next]
  #     redirect_to login_url, :alert => "You have to log in to continue."
  #   else
  #     #render :file => "#{Rails.root}/public/403.html", :status => 403
  #     if request.env["HTTP_REFERER"].present?
  #       redirect_to :back, :alert => exception.message
  #     else
  #       redirect_to root_url, :alert => exception.message
  #     end
  #   end
  # end
  
  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:stripe_card_token, :email, :password, :password_confirmation) }
    end
end
