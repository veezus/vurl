Fabricator(:click) do
  ip_address '127.0.0.1'
  user_agent '1337 browser'
end

Fabricator(:user) do
  name 'Anonymous'
  email {|u| "#{u.new_hash}@example.com"}
  password 'password'
end

Fabricator(:vurl) do
  after_create do |vurl|
    vurl.user = Fabricate(:user)
    vurl.save
  end
  url 'http://veez.us'
  title 'Veezus Kreist'
end

Fabricator(:vurl_with_clicks, :from => :vurl) do
  after_create do |v|
    v.clicks << Fabricate(:click, :vurl => v)
  end
end
