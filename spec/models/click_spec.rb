require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Click do
  describe "validation" do
    it "requires a vurl_id" do
      Click.new.should have(1).error_on(:vurl_id)
    end
    it "requires an ip_address" do
      Click.new.should have(1).error_on(:ip_address)
    end
    it "requires an user_agent" do
      Click.new.should have(1).error_on(:user_agent)
    end
  end

  describe "associations" do
    it "belongs to a vurl" do
      Click.new.should respond_to(:vurl)
    end
  end

  describe ".popular_vurls_since" do
    let(:vzs) { Factory(:vurl, :url => 'http://veez.us') }
    let(:exa) { Factory(:vurl, :url => 'http://example.com') }
    let(:nyt) { Factory(:vurl, :url => 'http://nytimes.com') }
    before do
      3.times { Factory(:click, :vurl => vzs) }
      9.times { Factory(:click, :vurl => nyt) }
      5.times { Factory(:click, :vurl => exa) }
    end
    it "returns the vurls with clicks from today" do
      Click.popular_vurls_since(1.day.ago).size.should == 3
    end
    it "returns the most popular first" do
      Click.popular_vurls_since(1.day.ago).first.should == [nyt, 9]
    end
    it "returns the least popular last" do
      Click.popular_vurls_since(1.day.ago).last.should == [vzs, 3]
    end
    it "limits results correctly" do
      Click.popular_vurls_since(1.day.ago, :limit => 2).size.should == 2
    end
  end
end
