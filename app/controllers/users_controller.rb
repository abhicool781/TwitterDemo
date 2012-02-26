class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    provider = "twitter";
    authorization = Authorization.find_by_provider_and_user_id(provider, @user.id)
    oauth_secret = authorization.secret
    oauth_token = authorization.token
    authenticate(oauth_token,oauth_secret)
    @tweets = Twitter.user_timeline
  end
  
  def tweet
    @user = User.find(params[:id])
    provider = "twitter";
    authorization = Authorization.find_by_provider_and_user_id(provider, @user.id)
    oauth_secret = authorization.secret
    oauth_token = authorization.token
    authenticate(oauth_token,oauth_secret)
    if !(params[:tweet]).nil?
      Twitter.update(params[:tweet])
    end
    sleep 5
    redirect_to :action => "show", :id => @user.id
  end
  
  def delete
    @user = User.find(params[:id])
    provider = "twitter";
    authorization = Authorization.find_by_provider_and_user_id(provider, @user.id)
    oauth_secret = authorization.secret
    oauth_token = authorization.token
    authenticate(oauth_token,oauth_secret)
    if !(params[:sid]).nil?
      Twitter.status_destroy(params[:sid])
    end
    sleep 5
    redirect_to :action => "show", :id => @user.id
  end

  def authenticate (oauth_token, oauth_secret)
    Twitter.configure do |config|
      config.consumer_key = TWITTER_KEY
      config.consumer_secret = TWITTER_SECRET
      config.oauth_token = "#{oauth_token}"
      config.oauth_token_secret = "#{oauth_secret}"
    end
  end
  
  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
end
