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
  it "displays the title if available" do
    @vurl.stub!(:title).and_return('a title')
    do_render
    response.body.should include('a title')
  end
  it "doesn't display the title if it's not available" do
    @vurl.stub!(:title).and_return('')
    do_render
    response.body.should_not include('Title:')
  end

  def do_render
    render "/vurls/show.html.haml"
  end
end
