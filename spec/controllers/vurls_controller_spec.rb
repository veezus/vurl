require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VurlsController do

  let(:vurl) { Fabricate(:vurl) }

  describe "when redirecting vurls" do
    describe "when the vurl is found" do
      before do
        Vurl.stub!(:find_by_slug).and_return(vurl)
      end
      it "redirects to the vurl's url with a 301 redirect" do
        get :redirect, slug: vurl.slug
        response.should redirect_to(vurl.url)
        response.status.should == 301
      end
      it "creates a click" do
        Click.should_receive(:new).with(vurl: vurl, ip_address: '0.0.0.0', user_agent: 'Rails Testing', referer: nil).and_return(stub(save: true))
        get :redirect, slug: 'AA'
      end
      it "logs the error if the click is not created" do
        click = Click.new(vurl: vurl, ip_address: nil, user_agent: nil)
        click.stub!(:save).and_return(false)
        Click.stub!(:new).and_return(click)
        controller.logger.should_receive(:warn).with("Couldn't create Click for Vurl (#{vurl.inspect}) because it had the following errors: #{click.errors}")
        get :redirect, slug: 'some slug'
      end
    end

    describe "when the slug contains non-slug characters" do
      it "finds the vurl only by the slug characters" do
        Vurl.should_receive(:find_by_slug).with("AAA").and_return(vurl)
        get :redirect, slug: "AAA,"
        response.should redirect_to(vurl.url)
      end
    end

    describe "when the vurl cannot be found" do
      before do
        Vurl.stub!(:find_by_slug).and_return(nil)
      end
      it "renders the not_found template" do
        get :redirect, slug: 'not_found'
        response.should redirect_to '/'
      end
    end
  end
end
