class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper
  helper_method :current_user, :sign_in?

  def current_user
    @current_user ||= User.find_by_id(current_user_id)
  end

  def sign_in?
    !!current_user
  end

  def skip_login
    redirect_to root_path if current_user
  end

  def require_login(path = nil)
    store_path(path)
    unless sign_in?
      flash[:alert] = 'Please login to your account'
      redirect_to :back
    end
  end
end
