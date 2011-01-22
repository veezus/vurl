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
  it "has a copy to clipboard link for each vurl" do
    visit root_path
    within(:css, "ul#vurl_#{vurl.id}") do
      page.should have_css("span.clippy")
    end
  end
  it "excludes spam vurls in the most popular list" do
    Vurl.destroy_all
    8.times do |i|
      Fabricate(:vurl).tap do |vurl|
        vurl.update_attribute(:title, "Vurl-#{i+1}")
        vurl.clicks.create! \
          :ip_address => '0.0.0.0',
          :user_agent => 'IE is here for your soul!'
      end
    end
    spam_vurl = Fabricate(:vurl).tap do |vurl|
      vurl.update_attribute(:title, "Vurl-spam")
      2.times do
        vurl.clicks.create! \
          :ip_address => '0.0.0.0',
          :user_agent => 'IE is here for your soul!'
      end
      vurl.flag_as_spam!
    end
    visit root_path
    page.should have_content("Vurl-1")
    page.should have_content("Vurl-2")
    page.should have_content("Vurl-3")
    page.should have_content("Vurl-4")
    page.should have_content("Vurl-5")
    page.should have_content("Vurl-6")
    page.should have_content("Vurl-7")
    page.should have_content("Vurl-8")
    page.should_not have_content("Vurl-spam")
  end
end
