Fabricator(:vurl) do
  user! { Fabricate(:user) }
  url 'http://veez.us'
  title 'Veezus Kreist'
end

Fabricator(:vurl_with_clicks, :from => :vurl) do
  after_create do |v|
    v.clicks << Fabricate(:click, :vurl => v)
  end
end
