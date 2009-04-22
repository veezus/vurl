require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper.rb')

describe "new vurl page" do
  before do
    @vurl = Vurl.new
    assigns[:vurl] = @vurl
    @vurl.stub!(:fetch_url_data).and_return(true)
  end
  it "has an I'm Feeling Lucky link" do
    render "/vurls/new.html.haml"
    response.should have_tag("a[href=?]", random_vurls_path, "I'm Feeling Lucky")
  end
  it "has most popular vurls" do
    vurl = Factory(:vurl, :title => 'title', :url => 'http://example.com')
    Vurl.stub!(:most_popular).and_return([vurl])
    render "/vurls/new.html.haml"
    response.should have_tag("a[href=?]", vurl.url, vurl.title)
  end
end
