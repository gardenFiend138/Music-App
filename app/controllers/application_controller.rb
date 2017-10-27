class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user

  def log_in_user!(user)
    session[:session_token] = user.session_token
  end

  def logged_in?
    !!current_user
  end

  def current_user
    #NOPE! \/
    # @current_user = User.find_by(session[:user][:email], session[:user][:password])
    # return if @current_user.nil?
    return nil unless session[:session_token]
    @current_user ||= User.find_by(session_token: session[:session_token])

  end

  def logout!
    current_user.reset_session_token!
    session[:session_token] = nil
  end

  def require_logged_in
    redirect_to new_session_url unless logged_in?
  end

  def require_logged_out
    redirect_to show_url if logged_in?
  end

  # def require_logged_out
  # end
  #
  # def require_logged_in
  # end

end
