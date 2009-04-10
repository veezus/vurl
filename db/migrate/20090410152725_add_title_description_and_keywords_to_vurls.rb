class AddTitleDescriptionAndKeywordsToVurls < ActiveRecord::Migration
  def self.up
    add_column :vurls, :title, :string
    add_column :vurls, :keywords, :string
    add_column :vurls, :description, :string
  end

  def self.down
    remove_column :vurls, :description
    remove_column :vurls, :keywords
    remove_column :vurls, :title
  end
end
