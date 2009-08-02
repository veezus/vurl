class AddUserIdToVurls < ActiveRecord::Migration
  def self.up
    add_column :vurls, :user_id, :integer
  end

  def self.down
    remove_column :vurls, :user_id
  end
end
