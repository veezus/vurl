require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper.rb')

describe "new vurl page" do
  before do
    assigns[:vurl] = Vurl.new
  end
  it "has an I'm Feeling Lucky link" do
    render "/vurls/new.html.haml"
    response.should have_tag("a[href=?]", random_vurls_path, "I'm Feeling Lucky")
  end
end
