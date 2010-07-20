require 'spec_helper'

describe FetchMetadata do
  it "fetches metadata for the passed in vurl id" do
    vurl = stub
    Vurl.should_receive(:find_by_id).with('1').and_return(vurl)
    vurl.should_receive(:fetch_metadata)
    FetchMetadata.perform('1')
  end
end
