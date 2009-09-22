class Click < ActiveRecord::Base
  belongs_to :vurl, :counter_cache => true
  validates_presence_of :vurl_id, :ip_address, :user_agent

  named_scope :by_day, lambda {|date| { :conditions => ["created_at >= ? AND created_at <= ?", date.midnight, (1.day.from_now(date.midnight) - 1.second)] } }
end
