Fabricator(:vurl) do
  url 'http://mattremsik.com'
  title 'Matt Remsik'
  user { Fabricate(:user) }
end

Fabricator(:vurl_with_clicks, :from => :vurl) do

  after_create do |v|
    v.clicks << Fabricate(:click, :vurl => v)
  end
end

Fabricator(:user) {}

Fabricator(:click) do
  ip_address '127.0.0.1'
  user_agent '1337 browser'
end
