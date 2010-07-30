class ActiveSupport::TestCase
  def current_path
    URI.parse(current_url).path
  end

  def visit_as_user(path)
    # request.cookies[:user_id] = user.id
    p page.driver.set_cookie("user_id;#{user.id}", URI.parse(page.current_url))
    visit path
  end

  def login_as(user)
    visit root_path
    click_link 'log in as another user'
    fill_in 'Email', :with => user.email
    fill_in 'Password', :with => 'password'
    click_button 'Log in'
  end
end
