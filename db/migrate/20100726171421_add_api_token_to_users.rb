class AddApiTokenToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :api_token, :string
  end

  def self.down
    remove_column :users, :api_token
  end
end
