require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper.rb')

describe "new vurl page" do
  before do
    @vurl = Vurl.new
    template.stub!(:new_vurl).and_return(@vurl)
    @vurl.stub!(:fetch_url_data).and_return(true)
    template.stub!(:recent_popular_vurls).and_return([])
    template.stub! :popular_period_links
  end
  it "has an I'm Feeling Lucky link" do
    render "/vurls/new.html.haml"
    response.should have_tag("a[href=?]", random_vurls_path, "I'm Feeling Lucky")
  end
  it "has most popular vurls" do
    vurl = Factory.build(:vurl, :title => 'title', :url => 'http://example.com')
    template.stub!(:recent_popular_vurls).and_return([vurl])
    render "/vurls/new.html.haml"
    response.should have_tag("a[href=?]", vurl.url, vurl.title)
  end
end
