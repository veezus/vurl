require 'factory_girl'

Factory.define :vurl do |vurl|
  vurl.url 'http://mattremsik.com'
  vurl.title 'Matt Remsik'
  vurl.association :user
end

Factory.define :user do |user|
end
