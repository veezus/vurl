class Click < ActiveRecord::Base
  belongs_to :vurl
  validates_presence_of :vurl_id, :ip_address, :user_agent
end
