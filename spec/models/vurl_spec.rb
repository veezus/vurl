require File.dirname(__FILE__) + '/../spec_helper'

describe "Vurl" do

  it "should require a url" do
    Factory.build(:vurl, :url => '').should_not be_valid
  end
  it "should require a valid url" do
    Factory.build(:vurl, :url => 'invalid_url').should_not be_valid
    Factory.build(:vurl, :url => 'http://sub-domain.mattremsik.com').should be_valid
  end
end
