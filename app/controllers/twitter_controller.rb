class TwitterController < ApplicationController
  def index
    tweets
    render :index, :layout => false
  end

  def tweets
    search = Twitter::Search.new('vurlme OR vurl.me')
    if params[:tweet_id]
      search.since(params[:tweet_id])
    else
      search
    end
  end
  helper_method :tweets
  hide_action   :tweets
end
