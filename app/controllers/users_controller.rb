class UsersController < ApplicationController

  def new 
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.valid?
      @user.save
      session[:user_id] = @user.id
      redirect_to @user
    else
      flash[:errors] = @user.errors.full_messages
      redirect_to new_user_path
    end
  end

  def show
    authorized?
    @user = User.find(params[:id])
  end

  private
  def user_params
    params.require(:user).permit(:username, :password)
  end
end