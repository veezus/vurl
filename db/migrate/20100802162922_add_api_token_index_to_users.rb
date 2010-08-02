class AddApiTokenIndexToUsers < ActiveRecord::Migration
  def self.up
    add_index :users, :api_token
  end

  def self.down
    remove_index :users, :column => :api_token
  end
end
