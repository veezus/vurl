class CreateClicks < ActiveRecord::Migration
  def self.up
    create_table :clicks do |t|
      t.integer :vurl_id
      t.string :ip_address
      t.text :user_agent

      t.timestamps
    end
  end

  def self.down
    drop_table :clicks
  end
end
