class UsersController < ApplicationController
  def update
    if current_user.claim(params[:user])
      flash[:success] = "Successfully saved your changes"
      redirect_to edit_user_path
    else
      flash.now[:error] = "There was a problem saving your changes"
      render :edit
    end
  end
end
