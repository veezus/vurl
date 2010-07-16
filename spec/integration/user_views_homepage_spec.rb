require 'spec_helper'

describe "User views homepage" do
  let(:vurl) { Fabricate(:vurl, :url => 'http://example.com') }
  before { Fabricate(:click, :vurl => vurl) }
  it "has an I'm Feeling Lucky link" do
    visit root_path
    page.body.should have_tag("button[url=?]", random_vurls_path, "I'm Feeling Lucky")
  end
  it "has most popular vurls" do
    visit root_path
    page.body.should have_tag("a[href=?]", vurl.url, vurl.title)
  end
  it "excludes spam vurls" do
    vurl.update_attribute(:title, 'New Title')
    vurl.flag_as_spam
    visit root_path
    page.body.should_not have_tag("a[href=?]", vurl.url, 'New Title')
  end
end
