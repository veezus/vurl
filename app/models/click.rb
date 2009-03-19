class Click < ActiveRecord::Base
  validates_presence_of :vurl_id, :ip_address, :user_agent
end
