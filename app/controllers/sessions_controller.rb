class SessionsController < ApplicationController

  caches_page :new
  
  def new
  end

  def create    
    user = User.authenticate(params[:user])

    if user
      session[:user_id] = user.id
      redirect_to home_path, :notice => "Successfully logged in"
    else
      flash[:alert] = "Invalid Username or Password."
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out"
  end

end

