class AddAuthlogicIndexesToUsers < ActiveRecord::Migration
  def self.up
    add_index :users, :persistence_token
    add_index :users, :single_access_token
  end

  def self.down
    remove_index :users, :column => :single_access_token
    remove_index :users, :column => :persistence_token
  end
end
