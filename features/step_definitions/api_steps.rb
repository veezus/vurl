When %Q(that user submits a JSON API request to shorten "http://veez.us") do
  visit shorten_path :format => :json, :url => "http://veez.us",
    :api_token => @user.api_token
end

When %Q(that user submits a non-JSON API request to shorten "http://blog.veez.us") do
  visit shorten_path :url => "http://veez.us", :api_token => @user.api_token
end

Then "the vurl was created and associated with that user" do
  Vurl.last.url.should == "http://veez.us"
  Vurl.last.user.should == @user
end
