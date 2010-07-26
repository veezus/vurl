class ActiveSupport::TestCase
  def current_path
    URI.parse(current_url).path
  end

  def visit_as_user(path)
    # request.cookies[:user_id] = user.id
    p page.driver.set_cookie("user_id;#{user.id}", URI.parse(page.current_url))
    visit path
  end
end
