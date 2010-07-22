class AddScreenshotQueuedToVurls < ActiveRecord::Migration
  def self.up
    add_column :vurls, :screenshot_queued, :boolean, :default => false
  end

  def self.down
    remove_column :vurls, :screenshot_queued
  end
end
