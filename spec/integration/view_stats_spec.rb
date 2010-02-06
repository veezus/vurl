require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe "View stats" do
  let(:vurl) { Factory(:vurl) }

  before { visit stats_path(vurl.slug) }

  it "displays the new vurl" do
    response.should have_tag("a[href=?]", redirect_url(vurl.slug), redirect_url(vurl.slug))
  end

  it "displays the link to view stats" do
    response.should have_tag("a[href=?]", stats_url(vurl.slug), stats_url(vurl.slug))
  end
end
