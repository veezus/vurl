class Click < ActiveRecord::Base
  belongs_to :vurl, counter_cache: true
  validates_presence_of :vurl_id, :ip_address, :user_agent

  scope :since, lambda {|date| { conditions: ["created_at >= ?", date] } }
end
