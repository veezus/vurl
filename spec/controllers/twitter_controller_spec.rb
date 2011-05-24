require 'spec_helper'

describe TwitterController do
  describe "GET index" do
    context "when no slug is provided" do
      let(:results) { stub }
      let(:search) { stub }
      before { Twitter::Search.should_receive(:new).and_return(search) }
      context "and a tweet id is provided" do
        it "returns tweets containing vurlme since the tweet" do
          search.should_receive(:q).with('vurlme OR vurl.me').and_return(search)
          search.should_receive(:since).with('1234')
          get :index, tweet_id: '1234'
        end
      end
      context "and no tweet id is provided" do
        it "returns tweets containing vurlme only" do
          search.should_receive(:q).with('vurlme OR vurl.me').and_return(results)
          get :index
        end
      end
    end
  end
end
