class AddScreenshotPathToVurls < ActiveRecord::Migration
  def self.up
    add_column :vurls, :screenshot_path, :string
  end

  def self.down
    remove_column :vurls, :screenshot_path
  end
end
