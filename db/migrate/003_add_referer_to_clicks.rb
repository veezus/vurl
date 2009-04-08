class AddRefererToClicks < ActiveRecord::Migration
  def self.up
    add_column :clicks, :referer, :string
  end

  def self.down
    remove_column :clicks, :referer
  end
end
