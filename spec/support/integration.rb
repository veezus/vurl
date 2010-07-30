class ActiveSupport::TestCase
  def current_path
    URI.parse(current_url).path
  end

  def login_as(user)
    visit root_path
    click_link 'log in as another user'
    fill_in 'Email', :with => user.email
    fill_in 'Password', :with => 'password'
    click_button 'Log in'
  end
end
