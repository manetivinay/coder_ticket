# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string
#  email           :string
#  password_digest :string
#  avatar          :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  context 'POST #create' do
    context 'create account successfully' do
      before(:each) do
        post :create, user: attributes_for(:user), format: :js
      end

      it 'should register successfully' do
        expect(User.count).to eq(1)
        expect(User.first.name).to eq('nongdenchet')
      end

      it 'user should be valid' do
        expect(assigns(:user).persisted?).to eq(true)
      end

      it 'should store user id' do
        expect(session[:user_id]).to eq(User.first.id)
      end
    end

    context 'skip login' do
      it 'should skip login' do
        @user = create(:user)
        session[:user_id] = @user.id
        post :create, user: {}
        expect(response).to redirect_to root_path
      end
    end

    context 'register fail' do
      it 'should not be store' do
        post :create, user: attributes_for(:user, email: '123'), format: :js
        expect(assigns(:user).new_record?).to eq(true)
      end
    end
  end

  context 'GET #edit' do
    before(:each) do
      @user = create(:user)
    end

    it 'should get user' do
      session[:user_id] = @user.id
      get :edit, id: @user.id
      expect(assigns(:user).id).to eq(@user.id)
    end

    it 'should render edit' do
      session[:user_id] = @user.id
      get :edit, id: @user.id
      expect(response).to render_template(:edit)
    end

    it 'should require login' do
      get :edit, id: @user.id
      expect(response).to redirect_to root_path
    end
  end

  context 'POST #update' do
    before(:each) do
      @user = create(:user)
    end

    context 'login user' do
      before(:each) do
        session[:user_id] = @user.id
      end

      it 'should show redirect to root' do
        post :update, id: @user.id, user: attributes_for(:user)
        expect(response).to redirect_to root_path
      end

      it 'should show flash' do
        post :update, id: @user.id, user: attributes_for(:user)
        expect(flash[:notice]).to eq('Update successfully')
      end

      it 'should render edit' do
        post :update, id: @user.id, user: attributes_for(:user, name: '')
        expect(response).to render_template(:edit)
      end
    end

    it 'should redirect to login' do
      post :update, id: @user.id, user: attributes_for(:user)
      expect(response).to redirect_to root_path
    end
  end
end
