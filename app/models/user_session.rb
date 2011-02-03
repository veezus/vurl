class UserSession < Authlogic::Session::Base
  def remember_me
    true
  end
  def remember_me_for
    5.years
  end
end
