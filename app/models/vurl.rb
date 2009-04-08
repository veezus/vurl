class Vurl < ActiveRecord::Base
  validates_presence_of :url
  validates_format_of   :url, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix
  has_many :clicks

  def self.random
    find(:first, :offset => (Vurl.count * rand).to_i)
  end

  def click_count
    clicks.count
  end

  def before_save
    if vurl = Vurl.find(:first, :order => 'slug DESC')
      self.slug = vurl.slug.succ
    else
      self.slug = 'AA'
    end
  end
end
