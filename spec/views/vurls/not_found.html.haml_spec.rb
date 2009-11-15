require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper.rb')

describe "new vurl page" do
  before do
    template.stub!(:recent_popular_vurls).and_return([])
    assigns[:most_popular_vurls] = []
  end
  it "has a title" do
    render "/vurls/not_found.html.haml"
    response.should have_tag("h2", "Not Found")
  end
  it "has a link to create a new vurl" do
    render "/vurls/not_found.html.haml"
    response.should have_tag("a[href=?]", new_vurl_path, "Create a new vurl")
  end
  it "has an I'm Feeling Lucky link" do
    render "/vurls/not_found.html.haml"
    response.should have_tag("a[href=?]", random_vurls_path, "I'm Feeling Lucky")
  end
  it "has most popular vurls" do
    vurl = Factory.build(:vurl, :title => 'title', :url => 'http://example.com')
    assigns[:most_popular_vurls] = [vurl]
    render "/vurls/not_found.html.haml"
    response.should have_tag("a[href=?]", vurl.url, vurl.title)
  end
  it "has recent popular vurls" do
    vurl = Factory.build(:vurl, :title => 'other title', :url => 'http://other.example.com')
    template.stub!(:recent_popular_vurls).and_return([vurl])
    render "/vurls/not_found.html.haml"
    response.should have_tag("a[href=?]", vurl.url, vurl.title)
  end
end
