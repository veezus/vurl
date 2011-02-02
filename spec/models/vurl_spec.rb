require File.dirname(__FILE__) + '/../spec_helper'

describe "Vurl" do

  let(:vurl) { Fabricate.build(:vurl) }

  describe "validations and associations" do
    subject { Vurl.new }

    it { should belong_to(:user) }
    it { should have_many(:clicks) }

    it { should validate_presence_of(:url) }
    it { should validate_presence_of(:user) }

    it { should allow_value('http://sub-domain.mattremsik.com').for(:url) }
    it { should allow_value('http://localhost/monkeys').for(:url) }
    it { should allow_value('http://localhost:3000/monkeys').for(:url) }
    it { should_not allow_value('invalid_url').for(:url) }
    it { should_not allow_value('http://vurl.me').for(:url) }
    it { should_not allow_value('https://vurl.me').for(:url) }
    it { should_not allow_value('http://www.vurl.me').for(:url) }
    it { should_not allow_value('https://www.vurl.me').for(:url) }
    it { should_not allow_value('http://vurl.me/').for(:url) }
    it { should_not allow_value('http://vurl.me/AA').for(:url) }
    it { should_not allow_value('http://blow-me.vurl.me/AA').for(:url) }

    it { should_not allow_value('tramadol').for(:title) }
    it { should_not allow_value('tramadol').for(:description) }
  end

  it "formats the url before validating" do
    vurl.should_receive(:format_url)
    vurl.valid?
  end

  context "after creation" do
    it "adds itself to queues" do
      vurl.should_receive(:add_to_queue).with(TakeScreenshot)
      vurl.should_receive(:add_to_queue).with(FetchMetadata)
      vurl.save(false)
    end
  end

  it "handles the switch to AAA" do
    zz = Fabricate(:vurl)
    zz.update_attribute(:slug, 'ZZ')
    aaa = Fabricate(:vurl)
    aaa.slug.should == 'AAA'
    aab = Fabricate(:vurl)
    aab.slug.should == 'AAB'
  end

  describe "#clicks_for_last" do
    let(:vurl) { Fabricate(:vurl) }

    context "hour" do
      it "returns a hash of minute => clicks" do
        click = Fabricate(:click, :vurl => vurl)
        vurl.clicks_for_last('hour').size.should == 1
        vurl.clicks_for_last('hour')[click.created_at.min.to_s].size.should == 1
      end
    end
  end

  describe ".random" do
    # Not entirely sure how to test this. Maybe stubbing count and rand and setting
    # an expectation that find is called with that offset? - Veezus
  end

  describe ".most_popular" do
    it "returns the correct number of vurls" do
      5.times { Fabricate(:vurl) }
      Vurl.most_popular(4).length.should == 4
    end
    it "has a default number of results" do
      6.times { Fabricate(:vurl) }
      Vurl.most_popular.length.should == 5
    end
  end

  describe ".popular_since" do
    let(:vzs) {
      vurl = Fabricate(:vurl, :url => 'http://veez.us')
      vurl.update_attribute(:created_at, 1.month.ago)
      vurl
    }
    let(:exa) { Fabricate(:vurl, :url => 'http://example.com') }
    let(:nyt) { Fabricate(:vurl, :url => 'http://nytimes.com') }
    before do
      Vurl.destroy_all
      3.times { Fabricate(:click, :vurl => vzs) }
      9.times { Fabricate(:click, :vurl => nyt) }
      5.times { Fabricate(:click, :vurl => exa) }
    end
    it "returns the vurls with clicks from today" do
      Vurl.popular_since(1.day.ago).size.should == 3
    end
    it "returns the most popular first" do
      vurl = Vurl.popular_since(1.day.ago).first
      vurl.should == nyt
      vurl.clicks_count.should == '9'
    end
    it "returns the least popular last" do
      vurl = Vurl.popular_since(1.day.ago).last
      vurl.should == vzs
      vurl.clicks_count.should == '3'
    end
    it "limits results correctly" do
      Vurl.popular_since(1.day.ago, :limit => 2).size.should == 2
    end
    it "returns an array with only one result" do
      Vurl.popular_since(1.minute.ago, :limit => 1).should be_a_kind_of(Array)
    end
  end

  describe "#take_screenshot!" do
    let(:vurl) { Fabricate(:vurl) }
    let(:screenshot) { stub(:snap! => true) }
    before do
      Screenshot.stub(:new).and_return(screenshot)

      class Vurl
        def take_screenshot!
          self.screenshot = Screenshot.new(:vurl => self).snap!
          self.screenshot_taken = true
          self.screenshot_queued = false
          save
        end
      end
    end

    it "delegates to Screenshot" do
      screenshot.should_receive(:snap!)
      vurl.take_screenshot!
    end

    it "notes that it has taken its screenshot" do
      vurl.take_screenshot!
      vurl.screenshot_taken.should be_true
    end

    it "notes that it is no longer queued" do
      vurl.screenshot_queued = true
      vurl.take_screenshot!
      vurl.screenshot_queued.should be_false
    end

    after do
      class Vurl
        def take_screenshot!
        end
      end
    end
  end

  describe "#add_to_queue" do
    context "when adding to the screenshot queue" do
      it "notes that it has been enqueued" do
        vurl.add_to_queue TakeScreenshot
        vurl.screenshot_queued.should be_true
      end
    end
    context "when adding to the metadata queue" do
      it "does not mark us as being in the screenshot queue" do
        vurl.add_to_queue FetchMetadata
        vurl.screenshot_queued.should be_false
      end
    end
  end

  describe "#clicks_count" do
    let(:vurl) { Vurl.new(:clicks_count => 17) }
    it "returns recent_clicks_count when present" do
      vurl.write_attribute(:recent_clicks_count, 12)
      vurl.clicks_count.should == 12
    end
    it "returns the number of clicks in the period passed" do
      vurl.clicks_count(1.hour.ago).should == 0
    end
    it "returns clicks_count otherwise" do
      vurl.clicks_count.should == 17
    end
  end

  describe "#summary_text" do
    let(:chars_255) { 'A' * 255 }
    let(:chars_50) { 'B' * 50 }
    context "when the description is filled out" do
      before do
        vurl.description = chars_255
        vurl.keywords = chars_50
      end
      it "uses the description" do
        vurl.summary_text.should == chars_255
      end
    end
    context "with partial description and loads of keywords" do
      before do
        vurl.description = chars_50
        vurl.keywords = chars_255
      end
      it "should return 255 characters" do
        vurl.summary_text.size.should == 255
      end
      it "returns the description plus keywords" do
        vurl.summary_text.should == (chars_50 + ' ' + chars_255).first(255)
      end
    end
    context "with partial description and a few keywords" do
      before do
        vurl.description = chars_50
        vurl.keywords = chars_50
      end
      it "returns description and keywords" do
        vurl.summary_text.should == chars_50 + ' ' + chars_50
      end
    end
  end

  describe "#fetch_metadata" do
    before do
      vurl.stub(:get_page => File.read(RAILS_ROOT + '/spec/data/nytimes_article.html'))
    end
    it "assigns a title" do
      vurl.should_receive(:title=).with('Suicide Attack Kills 5 G.I.’s and 2 Iraqis in Northern City - NYTimes.com')
      vurl.fetch_metadata
    end
    it "assigns keywords" do
      vurl.should_receive(:keywords=).with('Iraq,Iraq War (2003- ),United States Defense and Military Forces,Terrorism,Bombs and Explosives')
      vurl.fetch_metadata
    end
    it "assigns a description" do
      vurl.should_receive(:description=).with('The bombing of a Mosul police headquarters on Friday was the deadliest attack against American soldiers in 13 months.')
      vurl.fetch_metadata
    end
    it "truncates metadata" do
      vurl.should_receive(:truncate_metadata)
      vurl.fetch_metadata
    end
    it "saves any changes" do
      vurl.should_receive(:save)
      vurl.fetch_metadata
    end
  end

  describe "#format_url" do
    it "removes leading and trailing spaces" do
      vurl.url = '  http://google.com/ '
      vurl.send(:format_url)
      vurl.url.should == 'http://google.com/'
    end
  end

  describe "#truncate_metadata" do
    it "limits metadata to 255 characters" do
      invalid = "meta!data!" * 30 # 300 characters
      valid = invalid.first(255)
      metadata = %w(title description keywords)
      metadata.each {|metadatum| vurl.send("#{metadatum}=", invalid) }
      vurl.send(:truncate_metadata)
      metadata.each {|metadatum| vurl.send("#{metadatum}").should == valid }
    end
  end

  describe "#last_sixty_minutes" do
    it "returns the last sixty minutes" do
      time_now = Time.now
      vurl.last_sixty_minutes.size.should == 60
      vurl.last_sixty_minutes.each do |minute|
        minute.should be_close(time_now.change(:hour => time_now.hour, :minute => time_now.min), 1.hour + 2.seconds)
      end
    end
  end

  describe "#screenshot_taken?" do
    let(:vurl) { Vurl.new }
    context "when a screenshot has been taken" do
      before { vurl.screenshot_taken = true }
      it "does not queue a screenshot job" do
        vurl.should_not_receive(:add_to_queue).with(TakeScreenshot)
        vurl.screenshot_taken?
      end
      it "returns true" do
        vurl.screenshot_taken?.should be_true
      end
    end
    context "when a screenshot has not been taken" do
      before { vurl.screenshot_taken = false }
      context "and the job is already queued" do
        before { vurl.screenshot_queued = true }
        it "does not queue a screenshot job" do
          vurl.should_not_receive(:add_to_queue).with(TakeScreenshot)
          vurl.screenshot_taken?
        end
        it "returns false" do
          vurl.screenshot_taken?.should be_false
        end
      end
      context "and the job is not already queued" do
        it "enqueues a screenshot job" do
          vurl.should_receive(:add_to_queue).with(TakeScreenshot)
          vurl.screenshot_taken?
        end
        it "returns false" do
          vurl.stub(:add_to_queue)
          vurl.screenshot_taken?.should be_false
        end
      end
    end
  end

  describe "#metadata_fetched?" do
    it "returns true if the title is present" do
      vurl.title = 'title'
      vurl.metadata_fetched?.should be_true
    end
    it "returns true if the description is present" do
      vurl.description = 'description'
      vurl.metadata_fetched?.should be_true
    end
    it "returns false if title and description are blank" do
      vurl.title = vurl.description = ''
      vurl.metadata_fetched?.should be_false
    end
  end

  describe "#image?" do
    subject { vurl.image? }
    context "when extension is pdf" do
      before { vurl.url = "http://google.com/something.pdf" }
      it { should be_false }
    end
    context "when extension is html" do
      before { vurl.url = "http://google.com/something.html" }
      it { should be_false }
    end
    context "when extension is aspx" do
      before { vurl.url = "http://google.com/something.aspx" }
      it { should be_false }
    end
    context "when extension is jpg" do
      before { vurl.url = "http://google.com/something.jpg" }
      it { should be_true}
    end
    context "when extension is jpeg" do
      before { vurl.url = "http://google.com/something.jpeg" }
      it { should be_true}
    end
    context "when extension is gif" do
      before { vurl.url = "http://google.com/something.gif" }
      it { should be_true}
    end
    context "when extension is png" do
      before { vurl.url = "http://google.com/something.png" }
      it { should be_true}
    end
    context "when extension is bmp" do
      before { vurl.url = "http://google.com/something.bmp" }
      it { should be_true}
    end
  end
end
