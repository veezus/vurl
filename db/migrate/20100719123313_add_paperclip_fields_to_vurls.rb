class AddPaperclipFieldsToVurls < ActiveRecord::Migration
  def self.up
    add_column :vurls, :screenshot_file_name,    :string
    add_column :vurls, :screenshot_content_type, :string
    add_column :vurls, :screenshot_file_size,    :integer
    add_column :vurls, :screenshot_updated_at,   :datetime
  end

  def self.down
    remove_column :vurls, :screenshot_updated_at
    remove_column :vurls, :screenshot_file_size
    remove_column :vurls, :screenshot_content_type
    remove_column :vurls, :screenshot_file_name
  end
end
