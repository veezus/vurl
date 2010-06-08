class AddUserIdIndexToVurls < ActiveRecord::Migration
  def self.up
    add_index :vurls, :user_id
  end

  def self.down
    remove_index :vurls, :column => :user_id
  end
end
