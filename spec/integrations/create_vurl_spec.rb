require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe "Create Vurls" do
  it "redirects to the vurl stats page" do
    submit_vurl 'http://google.com'
    current_url.should == stats_url(Vurl.last.slug)
  end
  it "creates a vurl" do
    submit_vurl 'http://veez.us'
    Vurl.last.url.should == 'http://veez.us'
  end
end

def submit_vurl url
  visit root_path
  fill_in "vurl_url", :with => url
  click_button 'Vurlify!'
end
