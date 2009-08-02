class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :website
      t.string :blog
      t.string :claim_code

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
