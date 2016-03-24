require 'securerandom'

class FacebookAuthenticateService
  def initialize(auth)
    @auth = auth
  end

  def authenticate
    user = retrieve_user
    user = update_user(user)
    user.save && user
  end

  private
  def retrieve_user
    email = @auth[:info][:email] || "#{@auth[:uid]}@facebook.com"
    User.where(email: email).first_or_initialize
  end

  def update_user(user)
    secure = SecureRandom.hex
    user.name = @auth[:info][:name]
    user.remote_avatar_url = @auth[:info][:image].gsub('http://', 'https://')
    user.password = secure
    user.password_confirmation = secure
    user
  end
end