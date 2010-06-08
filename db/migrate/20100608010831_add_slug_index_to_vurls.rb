class AddSlugIndexToVurls < ActiveRecord::Migration
  def self.up
    add_index :vurls, :slug
  end

  def self.down
    remove_index :vurls, :column => :slug
  end
end
