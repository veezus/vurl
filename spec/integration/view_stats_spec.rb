require 'spec_helper'

describe "View stats" do
  let(:vurl) { Factory(:vurl) }

  before { visit stats_path(vurl.slug) }

  it "displays the new vurl" do
    page.should have_css("a[href='#{redirect_url(vurl.slug)}']", :text => redirect_url(vurl.slug))
  end

  it "displays the link to view stats" do
    page.should have_css("a[href='#{stats_url(vurl.slug)}']", :text => stats_url(vurl.slug))
  end
end
