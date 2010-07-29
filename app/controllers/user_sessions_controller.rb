class UserSessionsController < ApplicationController
  expose(:user_session) { UserSession.new(params[:user_session]) }

  def create
    if user_session.save
      flash[:success] = "Successfully logged in."
      redirect_to root_path
    else
      flash.now[:error] = "Couldn't log you in. Please try again."
      render :new
    end
  end
end
