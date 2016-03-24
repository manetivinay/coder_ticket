OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '1630403003898187', 'e3cb4b44d9bc68655743bfd080138a8a'
end