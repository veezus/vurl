class RemoveScreenshotPathFromVurls < ActiveRecord::Migration
  def self.up
    remove_column :vurls, :screenshot_path
  end

  def self.down
    add_column :vurls, :screenshot_path, :string
  end
end
