    
class SessionsController < ApplicationController

  def new 
  end

  def create 
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user
    else
      flash[:errors] = ['credentials does not match']
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to home_page_path
  end
  
end