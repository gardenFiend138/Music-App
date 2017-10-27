# REMEMBER! - controllers are named with capital letter and are pluralized

class UsersController < ApplicationController
  # helper_method :password # this is so it's available to use in the user params

  def new
    render :new
  end

  def show
    # @new_user = User.find_by_params()
    @new_user = User.find(self.params[:id])
    render :show
  end

  def create
    @user = User.new(user_params)
    if @user.save # attempt to save here, that way you can use it as a condition
      log_in_user!(@user) # this is an instance method
      # user_url takes a wildcard, and user_url is just a method; since
      # in your rails routes descriptions the URI pattern is users/:id,
      # it means that you need to pass it an argument; passing it the instance
      # variable @user, it will extract the id from that object
      redirect_to user_url(@user)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end


  private
  # This sets the private method, user_params, to be available to use
  # within this class. It calls the application controller built in method
  #(or does even appplication controller inherit this?), requires that
  # there be a user key, and only allows the user to input email and password

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
