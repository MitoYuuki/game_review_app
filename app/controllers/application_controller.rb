class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    posts_path
  end


  
  def after_sign_out_path_for(resource)
    root_path
  end


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :profile])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :profile])
  end

  def reject_guest_user
    if current_user.nil?
      flash[:alert] = "この操作をするにはログインが必要です"
      redirect_to new_user_session_path
    end
  end
end
