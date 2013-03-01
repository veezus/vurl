require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Click do
  describe "associations" do
    it "belongs to a vurl" do
      Click.new.should respond_to(:vurl)
    end
  end
end
