Rails.application.config.middleware.use OmniAuth::Builder do
    provider :rlauth, ENV['RLAUTH_KEY'], ENV['RLAUTH_SECRET']
end
