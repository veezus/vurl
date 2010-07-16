class SetDefaultStatusOnVurls < ActiveRecord::Migration
  def self.up
    execute "UPDATE vurls SET status = 'nominal' WHERE status IS NULL"
  end

  def self.down
    # No-op
  end
end
