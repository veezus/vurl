require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VurlsController do

  let(:vurl) { Fabricate(:vurl) }

  describe "when displaying an index of vurls" do
    it "renders the index view" do
      get :index
      response.should render_template('vurls/index')
    end
  end

  describe "when editing a vurl" do
    before(:each) do
      get :edit, id: vurl.id
    end
    it "should redirect when the edit action is called" do
      response.should be_redirect
    end
    it "should redirect to the new vurl page" do
      response.should redirect_to(new_vurl_url)
    end
    it "should redirect when the update action is called" do
      post :update, id: vurl.id
      response.should redirect_to(new_vurl_path)
    end
  end

  describe "when destroying vurls" do
    it "should redirect to the new vurls path" do
      post :destroy, id: Fabricate(:vurl).id
      response.should redirect_to(new_vurl_path)
    end
  end

  describe "when creating vurls" do
    it "should render the new form" do
      get :new
      response.should render_template(:new)
    end
    it "should redirect to the show page" do
      controller.stub(:new_vurl).and_return(vurl)
      post :create, vurl: {:url => "http://veez.us"}
      response.should redirect_to(stats_path(vurl.slug))
    end
    it "should set the ip address of the creator" do
      controller.stub(:new_vurl).and_return(vurl)
      vurl.should_receive(:ip_address=).with('0.0.0.0')
      post :create, vurl: vurl.attributes
    end
    it "assigns the current user as the vurls user" do
      user = Fabricate(:user)
      controller.stub(:current_user).and_return(user)
      post :create, vurl: {url: 'http://veez.us'}
      Vurl.last.user.should == user
    end
  end

  describe "when redirecting vurls" do
    describe "when the vurl is found" do
      before do
        Vurl.stub!(:find_by_slug).and_return(vurl)
      end
      it "redirects to the vurl's url with a 301 redirect" do
        get :redirect, slug: vurl.slug
        response.should redirect_to(vurl.url)
        response.status.should == "301 Moved Permanently"
      end
      it "creates a click" do
        Click.should_receive(:new).with(vurl: vurl, ip_address: '0.0.0.0', user_agent: 'Rails Testing', referer: nil).and_return(mock('click', save: true))
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
        response.should render_template('not_found')
      end
    end
  end

  describe "when viewing stats" do
    context "for an existing vurl" do
      let(:vurl) { Fabricate(:vurl) }
      it "find the vurl by the slug" do
        Vurl.should_receive(:find_by_slug).with(vurl.slug).and_return(vurl)
        get :stats, slug: vurl.slug
      end
      it "renders the show template" do
        get :stats, slug: vurl.slug
        response.should render_template(:show)
      end
    end

    context "for a non-existent vurl" do
      it "renders the not_found template" do
        get :stats, slug: 'not_found'
        response.should render_template('not_found')
      end
    end
  end

  describe "when redirecting to a random vurl" do
    before do
      Vurl.stub!(:random).and_return(vurl)
    end
    it "loads a random vurl" do
      Vurl.should_receive(:random).and_return(vurl)
      do_get
    end
    it "redirects to that vurl's url" do
      do_get
      response.should redirect_to(vurl.url)
    end

    def do_get
      get :random
    end
  end

  describe "#safe_url_for" do
    let(:vurl) { Fabricate(:vurl) }
    context "when the vurl is flagged as spam" do
      before { vurl.flag_as_spam! }
      it "returns the stats page URL" do
        controller.safe_url_for(vurl).should == spam_url(slug: vurl.slug)
      end
    end
    context "when the vurl is not flagged as spam" do
      it "returns the original URL" do
        controller.safe_url_for(vurl).should == vurl.url
      end
    end
  end
end
