require 'factory_girl'

Factory.define :vurl do |vurl|
  vurl.url 'http://mattremsik.com'
  vurl.title 'Matt Remsik'
  vurl.association :user
end

Factory.define :user do |user|
end

Factory.define :click do |click|
  click.ip_address '127.0.0.1'
  click.user_agent '1337 browser'
end
