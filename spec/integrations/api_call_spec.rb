require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe "Create Vurls via the API" do
  context "when successful" do
    it "creates a vurl" do
      visit shorten_path(:format => :json, :url => 'http://veez.us')
      Vurl.last.url.should == 'http://veez.us'
    end

    it "responds to a json request with a json response" do
      visit shorten_path(:format => :json, :url => 'http://veez.us')
      response.body.should == {:shortUrl => redirect_url(Vurl.last.slug)}.to_json
    end

    it "responds to an html request with an html response" do
      visit shorten_path(:url => 'http://veez.us')
      response.body.should == redirect_url(Vurl.last.slug)
    end
  end

  context "when unsuccessful" do
    it "returns a json object with the errors for a json request" do
      visit shorten_path(:format => :json, :url => 'whatthe?')
      response.body.should == {:errors => 'Url is invalid'}.to_json
    end

    it "returns a string with the errors for an html request" do
      visit shorten_path(:url => 'whatthe?')
      response.body.should == 'Url is invalid'
    end
  end

end
