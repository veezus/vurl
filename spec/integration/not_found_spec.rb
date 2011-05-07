require 'spec_helper'

describe "When the vurl is not found" do
  before do
    5.times do
      Fabricate(:vurl, clicks_count: 100)
    end
  end

  it "displays recent popular vurls" do
    recent_vurl = Fabricate :vurl, url: 'http://example.com/', title: 'Example.com', clicks_count: 101
    visit '/no-such-vurl'
    page.should have_css("a[href='#{recent_vurl.url}']", text: recent_vurl.title)
  end

  it "displays all-time popular vurls" do
    most_popular_vurl = Fabricate :vurl, url: 'http://example.com/', title: 'Oingo Boingo', clicks_count: 102
    most_popular_vurl.update_attribute(:created_at, 6.months.ago)
    visit '/no-such-vurl'
    page.should have_css("a[href='#{most_popular_vurl.url}']", text: most_popular_vurl.title)
  end
end
