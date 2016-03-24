# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string
#  email           :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  description     :text
#  avatar          :string
#

class UsersController < ApplicationController
  before_action :skip_login, only: [:create]
  before_action :require_login, except: [:create]
  before_action :get_user, only: [:edit, :update]

  def create
    @user = User.create(user_params)
    if @user.save
      store_user_id(@user.id)
    end
    respond_to :js
  end

  def edit
  end

  def update
    if @user.update_attributes(user_update_params)
      flash[:notice] = 'Update successfully'
      redirect_to root_path
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def user_update_params
    params.require(:user).permit(:name, :description, :avatar, :password, :password_confirmation)
  end

  def get_user
    @user = User.find(params[:id])
  end
end
