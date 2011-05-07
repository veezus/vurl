require 'spec_helper'

describe Screenshot do
  let(:vurl) { Fabricate(:vurl) }
  let(:screenshot) { Screenshot.new(vurl: vurl) }
  describe "#new" do
    it "takes a hash of options" do
      lambda { Screenshot.new({}) }.should_not raise_error
    end
    it "doesn't accept arbitrary keys" do
      lambda { Screenshot.new key: 'some value' }.should raise_error ArgumentError
    end
    it "accepts a vurl" do
      lambda { Screenshot.new vurl: vurl }.should_not raise_error
    end
  end

  describe "#snap!" do
    it "returns a tempfile" do
      screenshot.snap!.should be_a_kind_of(Tempfile)
    end
  end

  describe "#command" do
    it "begins with the path to the executable" do
      screenshot.command.should match(%r{#{Screenshot::PATH_TO_EXECUTABLE}})
    end
    it "includes the url as the second to last argument" do
      screenshot.command.split[-2].should == screenshot.url
    end
    it "outputs to STDOUT" do
      screenshot.command.split[-1].should == '-'
    end
    it "outputs png" do
      screenshot.command.should include("-f png")
    end
    it "crops to 1024x768" do
      screenshot.command.should include("--crop-w 1024")
      screenshot.command.should include("--crop-h 768")
    end
    it "sets the quality" do
      screenshot.command.should include("--quality 70")
    end
    it "allows time for javascript to execute" do
      screenshot.command.should include("--javascript-delay 1000")
    end
  end

  describe "method_missing madness" do
    it "returns values in the options hash when present" do
      screenshot.vurl.should == vurl
    end
  end

  describe "#url" do
    context "when vurl is an image" do
      it "returns the image_screenshot url" do
        vurl.stub(image?: true)
        screenshot.url.should == Shellwords.escape("http://test.host/vurls/image_screenshot?url=#{CGI.escape("http://veez.us")}")
      end
    end
    context "when not an image" do
      it "returns the vurl's url" do
        screenshot.url.should == "http://veez.us"
      end
    end
  end
end
