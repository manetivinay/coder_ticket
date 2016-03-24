require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  before(:each) do
    @user = create(:user)
  end

  context 'GET #callback' do
    context 'login facebook success' do
      before(:each) do
        user = double(User)
        allow(user).to receive(:id).and_return(1)
        allow_any_instance_of(FacebookAuthenticateService).to receive(:authenticate).and_return(user)
        get :callback, provider: :facebook
      end

      it 'should store user id' do
        expect(session[:user_id]).to eq(1)
      end

      it 'should show flash' do
        expect(flash[:notice]).to eq('Login successfully')
      end

      it 'should redirect to users_path' do
        expect(response).to redirect_to users_path
      end
    end

    context 'login facebook fail' do
      before(:each) do
        allow_any_instance_of(FacebookAuthenticateService).to receive(:authenticate).and_return(false)
        get :callback, provider: :facebook
      end

      it 'should redirect to root' do
        expect(response).to redirect_to(root_path)
      end

      it 'should show flash' do
        expect(flash.now[:alert]).to eq('Can not login with facebook')
      end
    end
  end

  context 'POST #create' do
    context 'valid email password' do
      before(:each) do
        post :create, email: 'nongdenchet@gmail.com', password: 'androidDeveloper'
      end

      it 'should login successfully' do
        expect(response).to redirect_to(root_path)
      end

      it 'should show successful flash' do
        expect(flash[:notice]).to eq('Login successfully')
      end

      it 'should store user id' do
        expect(session[:user_id]).to eq(@user.id)
      end
    end

    context 'skip login' do
      it 'should skip login' do
        session[:user_id] = @user.id
        post :create, email: 'aaa', password: 'aaa'
        expect(response).to redirect_to(root_path)
      end
    end

    context 'invalid email password' do
      before(:each) do
        post :create, {email: 'nongdenchet@gmail.com', password: '123'}
      end

      it 'should show invalid flash' do
        expect(flash[:alert]).to eq('Invalid email or password')
      end
    end
  end

  context 'DELETE #destroy' do
    before(:each) do
      session[:user_id] = @user.id
    end

    it 'should redirect to login page' do
      post :destroy
      expect(response).to redirect_to(root_path)
    end

    it 'should delete session' do
      post :destroy
      expect(session[:user_id]).to be_nil
    end

    it 'should show flash' do
      session[:user_id] = @user.id
      post :destroy
      expect(flash[:notice]).to eq('Logout successfully')
    end
  end
end
