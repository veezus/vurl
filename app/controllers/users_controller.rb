class UsersController < ApplicationController
  def update
    if current_user.update_attributes(params[:user])
      current_user.claim!
      flash[:success] = "Successfully saved your changes"
      redirect_to edit_user_path(current_user)
    else
      flash.now[:error] = "There was a problem saving your changes"
      render :edit
    end
  end
end
