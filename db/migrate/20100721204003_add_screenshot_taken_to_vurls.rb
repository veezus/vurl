class AddScreenshotTakenToVurls < ActiveRecord::Migration
  def self.up
    add_column :vurls, :screenshot_taken, :boolean, :default => false
  end

  def self.down
    remove_column :vurls, :screenshot_taken
  end
end
