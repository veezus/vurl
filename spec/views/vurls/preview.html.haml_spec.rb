require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper.rb')

describe "vurls show page" do
  before do
    @vurl = Factory(:vurl)
    assigns[:vurl] = @vurl
  end
  it "should display the clicks for this vurl" do
    @vurl.should_receive(:clicks_count).and_return(72250)
    do_render
    response.body.should include('72250')
  end
  def do_render
    render "/vurls/show.html.haml"
  end
end
