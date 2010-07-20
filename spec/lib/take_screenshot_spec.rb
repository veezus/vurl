require 'spec_helper'

describe TakeScreenshot do
  it "takes a screenshot for the passed in vurl id" do
    vurl = stub
    Vurl.should_receive(:find_by_id).with('1').and_return(vurl)
    vurl.should_receive(:take_screenshot!)
    TakeScreenshot.perform('1')
  end
end
