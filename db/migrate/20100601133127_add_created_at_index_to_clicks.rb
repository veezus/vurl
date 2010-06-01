class AddCreatedAtIndexToClicks < ActiveRecord::Migration
  def self.up
    add_index :clicks, :created_at
  end

  def self.down
    remove_index :clicks, :column => :created_at
  end
end
