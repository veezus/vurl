require 'digest'

class User < ActiveRecord::Base
  has_many :vurls

  before_create :generate_claim_code, :set_default_name

  def claimed?
    claim_code.blank?
  end

  def claim!
    self.update_attribute(:claim_code, nil)
  end

  def unclaimed?
    !claimed?
  end

  private

  def set_default_name
    self.name = 'Anonymous'
  end

  def generate_claim_code
    self.claim_code = Digest::SHA1.hexdigest(Time.now.to_s + (rand * 10_000).to_s)
  end
end
