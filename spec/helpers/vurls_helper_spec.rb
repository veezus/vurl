require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VurlsHelper do
  describe "#display_stats_link?" do
    it "returns false if we're showing a vurl" do
      helper.stub(:controller_name).and_return('vurls')
      helper.stub(:action_name).and_return('stats')
      helper.display_stats_link?.should be_false
    end
    it "returns true elsewise" do
      helper.display_stats_link?.should be_true
    end
  end
end
