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
end
