require 'spec_helper'

describe "User views homepage" do
  it "has an I'm Feeling Lucky link" do
    visit root_path
    page.body.should have_tag("button[url=?]", random_vurls_path, "I'm Feeling Lucky")
  end
  it "has most popular vurls" do
    vurl = Factory(:vurl, :title => 'title', :url => 'http://example.com')
    Factory(:click, :vurl => vurl)
    visit root_path
    page.body.should have_tag("a[href=?]", vurl.url, vurl.title)
  end
end
