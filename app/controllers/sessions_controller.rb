class SessionsController < ApplicationController

  before_action :require_logged_out, only: [:new, :create]

  def log_in_user(user)
    # generate_session_token => NOPE
    # the left side returns a particular instance of user, the right
    # side sets the session_token
    session[:session_token] = user.session_token
  end

  def logged_in?
    # session[:session_token]
    !!current_user
  end

  def create
    user = User.find_by_credentials(params[:user][:email], params[:user][:password])
    if user.nil?
      flash.now[:errors] = ["Invalid username or password."]
      redirect_to new_session_url
    else
      log_in_user!(user)
      redirect_to "/users/#{@user}"
    end
  end

  def destroy
    logout!
    redirect_to new_session_url
  end

  def new
    render :new
  end

end
