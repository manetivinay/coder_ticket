require 'rails_helper'

RSpec.describe FacebookAuthenticateService do
  before(:each) do
    auth = {
        info: {
            email: 'ndc@gmail.com',
            name: 'nongdenchet',
            image: 'https://vipei.ca/img/default_avatar.jpg'
        },
        uid: 'quan'
    }
    allow_any_instance_of(ImageUploader).to receive(:download!)
    @service = FacebookAuthenticateService.new(auth)
  end

  it 'should save user' do
    expect(@service.authenticate.persisted?).to eq(true)
  end

  context 'save success' do
    before(:each) do
      @service.authenticate
      @user = User.first
    end

    it 'user should be saved' do
      expect(@user.persisted?).to eq(true)
    end

    it 'should have right name' do
      expect(@user.name).to eq('nongdenchet')
    end

    it 'should have right email' do
      expect(@user.email).to eq('ndc@gmail.com')
    end
  end
end