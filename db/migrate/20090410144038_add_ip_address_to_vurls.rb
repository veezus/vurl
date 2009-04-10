class AddIpAddressToVurls < ActiveRecord::Migration
  def self.up
    add_column :vurls, :ip_address, :string
  end

  def self.down
    remove_column :vurls, :ip_address
  end
end
