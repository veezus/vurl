class AddVurlIdIndexToClicks < ActiveRecord::Migration
  def self.up
    add_index :clicks, :vurl_id
  end

  def self.down
    remove_index :clicks, :column => :vurl_id
  end
end
