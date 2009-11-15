require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe "When the vurl is not found" do
  before do
    5.times do
      Factory(:vurl, :clicks_count => 100)
    end
  end

  it "displays recent popular vurls" do
    recent_vurl = Factory :vurl, :url => 'http://example.com/', :title => 'Example.com', :clicks_count => 101
    visit '/no-such-vurl'
    response.should have_tag("a[href=?]", recent_vurl.url, recent_vurl.title)
  end

  it "displays all-time popular vurls" do
    most_popular_vurl = Factory :vurl, :url => 'http://oingoboingo.com/', :title => 'Oingo Boingo', :clicks_count => 101
    most_popular_vurl.update_attribute(:created_at, 6.months.ago)
    visit '/no-such-vurl'
    response.should have_tag("a[href=?]", most_popular_vurl.url, most_popular_vurl.title)
  end
end
