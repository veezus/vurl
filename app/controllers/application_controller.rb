class ApplicationController < ActionController::Base
  protect_from_forgery

  expose(:current_period) { params[:period].present? ? params[:period] : 'hour' }
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
