require File.dirname(__FILE__) + '/../spec_helper'

describe "Vurl" do

  it "should require a url" do
    Factory.build(:vurl, :url => '').should_not be_valid
  end
  it "should require a valid url" do
    Factory.build(:vurl, :url => 'invalid_url').should_not be_valid
    Factory.build(:vurl, :url => 'http://sub-domain.mattremsik.com').should be_valid
  end
  it "has many clicks" do
    Vurl.new.should respond_to(:clicks)
  end

  describe ".random" do
    # Not entirely sure how to test this. Maybe stubbing count and rand and setting
    # an expectation that find is called with that offset? - Veez
  end

  describe "#click_count" do
    it "knows how many clicks it has" do
      vurl = Vurl.new
      vurl.clicks.should_receive(:count).and_return(7)
      vurl.click_count.should == 7
    end
  end
end
