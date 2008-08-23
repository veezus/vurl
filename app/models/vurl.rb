class Vurl < ActiveRecord::Base
  validates_presence_of :url

  def before_save
    if vurl = Vurl.find(:first, :order => 'slug DESC')
      self.slug = vurl.slug.succ
    else
      self.slug = 'AAAA'
    end
  end
end
