class AuthorizationsController < ApplicationController
  # GET /authorizations
  # GET /authorizations.json
  def callback
    auth_hash = request.env['omniauth.auth']
    render :text=> auth_hash.inspect
    
  end

  def authenticate (oauth_token, oauth_secret)
    Twitter.configure do |config|
      config.consumer_key = TWITTER_KEY
      config.consumer_secret = TWITTER_SECRET
      config.oauth_token = "#{oauth_token}"
      config.oauth_token_secret = "#{oauth_secret}"
    end
  end

end
