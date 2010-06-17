require 'spec_helper'

describe "View stats" do
  let(:vurl) { Factory(:vurl) }

  it "displays the new vurl" do
    visit stats_path(vurl.slug)
    page.should have_css("a[href='#{redirect_url(vurl.slug)}']", :text => redirect_url(vurl.slug))
  end

  context "with clicks more than an hour old" do
    before do
      3.times { Factory(:click, :vurl => vurl) }
      vurl.clicks.last.update_attribute(:created_at, 2.hours.ago)
      visit stats_path(vurl.slug)
    end
    it "displays the number of clicks within the last hour" do
      page.should_not have_content("3 in the last hour")
      page.should have_content("2 in the last hour")
    end
    it "displays the total number of clicks" do
      page.should have_content("3 total clicks")
    end
  end
end
