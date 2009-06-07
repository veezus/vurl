require 'factory_girl'

Factory.define :vurl do |vurl|
  vurl.url 'http://mattremsik.com'
  vurl.title 'Matt Remsik'
end
