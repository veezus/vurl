# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  filter_parameter_logging :password

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '5ee0c1f9ce72a776ebba8a8c3338e3d2'

  expose(:current_period) { params[:period].present? ? params[:period] : 'hour' }
  expose(:current_vurl) do
    if slug = params[:slug]
      slug = slug[/^\w+/]
      Vurl.find_by_slug(slug)
    else
      Vurl.find_by_id(params[:id])
    end
  end
  expose(:authlogic_user_session) { UserSession.find }

  protected

  def current_user
    @current_user ||= (load_user_from_authlogic || load_user_from_cookie || create_user)
  end
  helper_method :current_user

  def load_user_from_authlogic
    authlogic_user_session && authlogic_user_session.record
  end

  def load_user_from_cookie
    User.find_by_id(cookies[:user_id]) if cookies[:user_id]
  end

  def create_user
    user = User.create!
    cookies[:user_id] = {value: user.id, expires: 5.years.from_now}
    user
  end

  def suspected_spam_user?
    %w(76.168.113.69 84.46.116.13).include? request.remote_ip
  end

end
