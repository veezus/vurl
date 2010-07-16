class AddStatusToVurls < ActiveRecord::Migration
  def self.up
    add_column :vurls, :status, :string
  end

  def self.down
    remove_column :vurls, :status
  end
end
