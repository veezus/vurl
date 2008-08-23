class CreateVurls < ActiveRecord::Migration
  def self.up
    create_table :vurls do |t|
      t.string :url
      t.string :slug

      t.timestamps
    end
  end

  def self.down
    drop_table :vurls
  end
end
