require File.dirname(__FILE__) + '/../spec_helper'

describe "Vurl" do

  before do
    @vurl = Vurl.new
  end

  describe "validations and associations" do
    subject { @vurl }

    it { should belong_to(:user) }
    it { should have_many(:clicks) }

    it { should validate_presence_of(:url) }
    it { should validate_presence_of(:user) }

    it { should allow_value('http://sub-domain.mattremsik.com').for(:url) }
    it { should_not allow_value('invalid_url').for(:url) }
  end

  it "formats the url before validating" do
    @vurl.should_receive(:format_url)
    @vurl.valid?
  end

  it "should fetch url data before saving" do
    @vurl.should_receive(:fetch_url_data)
    @vurl.save_without_validation
  end

  it "handles the switch to AAA" do
    @vurl.save_without_validation
    @vurl.update_attribute(:slug, 'ZZ')
    other_vurl = Vurl.new
    other_vurl.save_without_validation
    other_vurl.write_attribute(:slug, 'AAA')
    new_vurl = Vurl.new
    new_vurl.save_without_validation
    new_vurl.slug.should == 'AAB'
  end

  describe ".random" do
    # Not entirely sure how to test this. Maybe stubbing count and rand and setting
    # an expectation that find is called with that offset? - Veez
  end

  describe ".most_popular" do
    it "returns the correct number of vurls" do
      5.times { Factory(:vurl) }
      Vurl.most_popular(4).length.should == 4
    end
    it "has a default number of results" do
      6.times { Factory(:vurl) }
      Vurl.most_popular.length.should == 5
    end
  end

  describe "#fetch_url_data" do
    before do
      @vurl.stub!(:construct_url).and_return(RAILS_ROOT + '/spec/data/nytimes_article.html')
    end
    it "assigns a title" do
      @vurl.should_receive(:title=).with('Suicide Attack Kills 5 G.I.’s and 2 Iraqis in Northern City - NYTimes.com')
      @vurl.fetch_url_data
    end
    it "assigns keywords" do
      @vurl.should_receive(:keywords=).with('Iraq,Iraq War (2003- ),United States Defense and Military Forces,Terrorism,Bombs and Explosives')
      @vurl.fetch_url_data
    end
    it "assigns a description" do
      @vurl.should_receive(:description=).with('The bombing of a Mosul police headquarters on Friday was the deadliest attack against American soldiers in 13 months.')
      @vurl.fetch_url_data
    end
    it "truncates metadata" do
      @vurl.should_receive(:truncate_metadata)
      @vurl.fetch_url_data
    end
  end

  describe "#format_url" do
    it "removes leading and trailing spaces" do
      @vurl.url = '  http://google.com/ '
      @vurl.send(:format_url)
      @vurl.url.should == 'http://google.com/'
    end
  end

  describe "#truncate_metadata" do
    it "limits metadata to 255 characters" do
      invalid = "meta!data!" * 30 # 300 characters
      valid = invalid.first(255)
      metadata = %w(title description keywords)
      metadata.each {|metadatum| @vurl.send("#{metadatum}=", invalid) }
      @vurl.send(:truncate_metadata)
      metadata.each {|metadatum| @vurl.send("#{metadatum}").should == valid }
    end
  end

  describe "#days_with_clicks" do
    it "returns a distinct list of days" do
      @vurl = Factory(:vurl)
      click_one = Factory(:click, :vurl => @vurl)
      click_two = Factory(:click, :vurl => @vurl)

      click_one.update_attribute(:created_at, DateTime.new(2009, 12, 31, 10, 30))
      click_two.update_attribute(:created_at, DateTime.new(2009, 12, 31, 16, 30))

      @vurl.days_with_clicks.size.should == 1
      @vurl.days_with_clicks.first.year.should == 2009
      @vurl.days_with_clicks.first.month.should == 12
      @vurl.days_with_clicks.first.day.should == 31
    end
  end

  describe "#hours_with_clicks" do
    it "returns a distinct list of hours" do
      @vurl = Factory(:vurl)
      click_one = Factory(:click, :vurl => @vurl)
      click_two = Factory(:click, :vurl => @vurl)
      click_three = Factory(:click, :vurl => @vurl)

      click_one.update_attribute(:created_at, DateTime.new(2009, 12, 31, 10, 30))
      click_two.update_attribute(:created_at, DateTime.new(2009, 12, 31, 10, 31))
      click_three.update_attribute(:created_at, DateTime.new(2009, 12, 31, 16, 30))

      @vurl.hours_with_clicks.size.should == 2

      @vurl.hours_with_clicks.first.year.should == 2009
      @vurl.hours_with_clicks.first.month.should == 12
      @vurl.hours_with_clicks.first.day.should == 31
      @vurl.hours_with_clicks.first.hour.should == 10

      @vurl.hours_with_clicks.last.year.should == 2009
      @vurl.hours_with_clicks.last.month.should == 12
      @vurl.hours_with_clicks.last.day.should == 31
      @vurl.hours_with_clicks.last.hour.should == 16
    end
  end

  describe "#last_sixty_minutes" do
    it "returns the last sixty minutes" do
      time_now = Time.now
      @vurl.last_sixty_minutes.size.should == 60
      @vurl.last_sixty_minutes.each do |minute|
        minute.should be_close(time_now.change(:hour => time_now.hour, :minute => time_now.min), 1.hour + 2.seconds)
      end
    end
  end

  describe "#chart_with_hours?" do
    it "returns true if hours with clicks is less than or equal to 16" do
      hour_clicks = []
      15.times { hour_clicks << ['a click'] }
      @vurl.stubs(:hours_with_clicks).returns(hour_clicks)
      @vurl.chart_with_hours?.should be_true
      hour_clicks << ['a new click']
      @vurl.chart_with_hours?.should be_true
    end

    it "returns false if hours with clicks is more than 16" do
      hour_clicks = []
      17.times { hour_clicks << ['a click'] }
      @vurl.stubs(:hours_with_clicks).returns(hour_clicks)
      @vurl.chart_with_hours?.should be_false
    end
  end

  describe "#click_periods" do
    it "returns hours if the vurl should chart with hours" do
      @vurl.stubs(:chart_with_hours?).returns(true)
      @vurl.expects(:hours_with_clicks)
      @vurl.click_periods
    end

    it "returns days if the vurl should chart with days" do
      @vurl.stubs(:chart_with_hours?).returns(false)
      @vurl.expects(:days_with_clicks)
      @vurl.click_periods
    end
  end
end
