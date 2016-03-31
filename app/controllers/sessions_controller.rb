class SessionsController < ApplicationController
  before_action :skip_login, only: [:create]
  before_action :require_login, only: [:destroy]

  def create
    @authenticate = authenticate
    store_user_id(@user.id) if @authenticate
    respond_to :js
  end

  def callback
    if (user = FacebookAuthenticateService.new(env['omniauth.auth']).authenticate)
      store_user_id(user.id)
    else
      flash[:alert] = 'Can not login with facebook'
    end
    redirect_to root_path
  end

  def destroy
    clear_user_id
    flash[:notice] = 'Logout successfully'
    redirect_to root_path
  end

  private
  def authenticate
    @user = User.find_by(email: params[:email])
    @user && @user.authenticate(params[:password])
  end
end
