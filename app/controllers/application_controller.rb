# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '5ee0c1f9ce72a776ebba8a8c3338e3d2'

  protected

  def current_user
    @current_user ||= (load_user_from_cookie || create_user)
  end
  helper_method :current_user

  def load_user_from_cookie
    User.find_by_id(cookies[:user_id]) if cookies[:user_id]
  end

  def create_user
    user = User.create!
    cookies[:user_id] = user.id
    user
  end
end
