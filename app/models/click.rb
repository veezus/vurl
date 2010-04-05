class Click < ActiveRecord::Base
  belongs_to :vurl, :counter_cache => true
  validates_presence_of :vurl_id, :ip_address, :user_agent

  named_scope :since, lambda {|date| { :conditions => ["created_at >= ?", date] } }

  def self.popular_vurls_since(period_ago, options={})
    limit = options[:limit] || 5
    results = Click.since(period_ago).group_by(&:vurl).map{|v,cs| [v, cs.size]}.sort_by{|r| r.last}.reverse
    results.first(limit)
  end
end
