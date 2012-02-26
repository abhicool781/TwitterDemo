class AuthorizationsController < ApplicationController
  # GET /authorizations
  # GET /authorizations.json
  def callback
    auth_hash = request.env['omniauth.auth']
    #render :text=> auth_hash.inspect
    @authorization = Authorization.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
    if @authorization
      oauth_token = auth_hash['credentials']['token']
      oauth_secret = auth_hash['credentials']['secret']
      authenticate oauth_token, oauth_secret
      #Twitter.update("From my app")
      #render :text => "Welcome back #{@authorization.user.name}! You have already signed up." 
      @users = User.all
    else
      user = User.new :name => auth_hash["info"]["name"], :nickname => auth_hash["info"]["nickname"]
      user.authorizations.build :provider => auth_hash["provider"], :uid => auth_hash["uid"], :token => auth_hash['credentials']['token'], 
      :secret => auth_hash['credentials']['secret'], :image_url => auth_hash["info"]["image"]
      user.save
      msg = "Hi #{user.name}! You've signed up.\n Registered Users :" 
      @users = User.all
    end
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
