require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VurlsController do
  integrate_views

  before do
    @vurl = Factory.build(:vurl)
  end

  describe "when displaying an index of vurls" do
    it "should redirect when the index action is called" do
      get :index
      response.should be_redirect
    end
    it "should redirect to the new vurl page" do
      get :index
      response.should redirect_to(new_vurl_url)
    end
  end

  describe "when editing a vurl" do
    before(:each) do
      get :edit, :id => @vurl.id
    end
    it "should redirect when the edit action is called" do
      response.should be_redirect
    end
    it "should redirect to the new vurl page" do
      response.should redirect_to(new_vurl_url)
    end
    it "should redirect when the update action is called" do
      post :update, :id => @vurl.id
      response.should redirect_to(new_vurl_path)
    end
  end

  describe "when destroying vurls" do
    it "should redirect to the new vurls path" do
      post :destroy, :id => Factory.create(:vurl).id
      response.should redirect_to(new_vurl_path)
    end
  end

  describe "when showing vurls" do
    it "should render the show action" do
      vurl = Factory(:vurl)
      get :show, :id => vurl.id
      response.should render_template(:show)
    end
  end

  describe "when creating vurls" do
    before do
      Vurl.stub!(:new).and_return(@vurl)
    end
    it "should render the new form" do
      get :new
      response.should render_template(:new)
    end
    it "should redirect to the show page" do
      post :create, :vurl => @vurl.attributes
      #FIXME Incrementing vurl.id feels wrong
      response.should redirect_to(vurl_path(@vurl))
    end

    it "should set the ip address of the creator" do
      Vurl.should_receive(:new).and_return(@vurl)
      @vurl.should_receive(:ip_address=).with('0.0.0.0')
      post :create, :vurl => @vurl.attributes
    end

  end

  describe "when redirecting vurls" do
    describe "when the vurl is found" do
      before do
        Vurl.stub!(:find_by_slug).and_return(@vurl)
      end
      it "creates a click" do
        Click.should_receive(:new).with(:vurl => @vurl, :ip_address => '0.0.0.0', :user_agent => 'Rails Testing', :referer => nil).and_return(mock('click', :save => true))
        get :redirect, :slug => 'AA'
      end
      it "logs the error if the click is not created" do
        click = Click.new(:vurl => @vurl, :ip_address => nil, :user_agent => nil)
        click.stub!(:save).and_return(false)
        Click.stub!(:new).and_return(click)
        controller.logger.should_receive(:warn).with("Couldn't create Click for Vurl (#{@vurl.inspect}) because it had the following errors: #{click.errors}")
        get :redirect, :slug => 'some slug'
      end
    end

    describe "when the vurl cannot be found" do
      before do
        Vurl.stub!(:find_by_slug).and_return(nil)
      end
      it "loads all-time most popular vurls" do
        controller.should_receive(:load_most_popular_vurls)
        controller.instance_variable_set(:@most_popular_vurls, [])
        get :redirect, :slug => 'not_found'
      end
      it "loads recent popular vurls" do
        controller.should_receive(:load_recent_popular_vurls)
        controller.instance_variable_set(:@recent_popular_vurls, [])
        get :redirect, :slug => 'not_found'
      end
      it "renders the not_found template" do
        get :redirect, :slug => 'not_found'
        response.should render_template('not_found')
      end
    end
  end

  describe "when previewing vurls" do
    it "should render the preview form" do
      @vurl.url = 'http://hashrocket.com/'
      Vurl.stub!(:find_by_slug).and_return(@vurl)
      get :preview, :slug => @vurl.slug
      response.should render_template(:preview)
    end
  end

  describe "when redirecting to a random vurl" do
    before do
      Vurl.stub!(:random).and_return(@vurl)
    end
    it "loads a random vurl" do
      Vurl.should_receive(:random).and_return(@vurl)
      do_get
    end
    it "redirects to that vurl's url" do
      do_get
      response.should redirect_to(@vurl.url)
    end

    def do_get
      get :random
    end
  end

  describe "#load_most_popular_vurls" do
    it "asks Vurl for the all-time most popular vurls" do
      Vurl.should_receive(:most_popular).and_return([])
      controller.send(:load_most_popular_vurls)
      controller.instance_variable_get(:@most_popular_vurls).should == []
    end
  end

  describe "#load_recent_popular_vurls" do
    it "asks Vurl for the recent popular vurls" do
      since = mock('named scope')
      Vurl.should_receive(:since).and_return(since)
      since.should_receive(:most_popular).and_return([])
      controller.send(:load_recent_popular_vurls)
      controller.instance_variable_get(:@recent_popular_vurls).should == []
    end
  end
end
