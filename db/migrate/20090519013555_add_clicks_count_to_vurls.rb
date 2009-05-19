class AddClicksCountToVurls < ActiveRecord::Migration
  def self.up
    add_column :vurls, :clicks_count, :integer, :default => 0
  end

  def self.down
    remove_column :vurls, :clicks_count
  end
end
