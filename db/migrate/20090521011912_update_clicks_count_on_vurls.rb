class Click < ActiveRecord::Base; end
class Vurl < ActiveRecord::Base; has_many :clicks; end
class UpdateClicksCountOnVurls < ActiveRecord::Migration
  def self.up
    Vurl.all.each do |vurl|
      vurl.clicks_count = vurl.clicks.count
      vurl.save!
    end
  end

  def self.down
  end
end
