require 'spec_helper'

describe "Create Vurls via the API" do
  context "when successful" do
    it "creates a vurl" do
      visit shorten_path(format: :json, url: 'http://veez.us')
      Vurl.last.url.should == 'http://veez.us'
    end

    it "responds to a json request with a json response" do
      visit shorten_path(format: :json, url: 'http://veez.us')
      page.body.should == {shortUrl: redirect_url(Vurl.last.slug)}.to_json
    end

    it "responds to an html request with an html response" do
      visit shorten_path(url: 'http://veez.us')
      page.body.should == redirect_url(Vurl.last.slug)
    end

    context "with an api token provided" do
      it "associates the vurl with the provided user" do
        user = Fabricate(:user)
        visit shorten_path(url: 'http://coreyhaines.com', api_token: user.api_token)
        user.should have_vurls
      end
    end
  end

  context "when unsuccessful" do
    it "returns a json object with the errors for a json request" do
      visit shorten_path(format: :json, url: 'whatthe?')
      page.body.should == {errors: 'Url is invalid'}.to_json
    end

    it "returns a string with the errors for an html request" do
      visit shorten_path(url: 'whatthe?')
      page.body.should include('Url is invalid')
    end
  end

end
