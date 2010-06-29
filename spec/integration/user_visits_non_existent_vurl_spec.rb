require 'spec_helper'

describe "new vurl page" do
  let(:vurl) { Fabricate(:vurl_with_clicks) }
  before do
    vurl
    visit redirect_url("no-such-slug")
  end
  it "has a title" do
    page.body.should have_tag("h2", "Not Found")
  end
  it "has a link to create a new vurl" do
    page.body.should have_tag("a[href=?]", new_vurl_path, "Create a new vurl")
  end
  it "has an I'm Feeling Lucky link" do
    page.body.should have_tag("a[href=?]", random_vurls_path, "I'm Feeling Lucky")
  end
  it "has popular vurls" do
    page.body.should have_tag("a[href=?]", vurl.url, vurl.title)
  end
end
