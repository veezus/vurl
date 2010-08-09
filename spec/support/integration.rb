class ActiveSupport::TestCase
  def current_path
    URI.parse(current_url).path
  end

  def login_as(user)
    page.cleanup!
    visit new_user_session_path
    fill_in 'Email', :with => user.email
    fill_in 'Password', :with => 'password'
    click_button 'Log in'
  end

  def submit_vurl url
    visit root_path
    fill_in "vurl_url", :with => url
    click 'Vurlify!'
  end
end
