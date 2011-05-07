require 'digest'

class User < ActiveRecord::Base
  acts_as_authentic do |config|
    config.validate_email_field false
    config.require_password_confirmation false
    config.logged_in_timeout 5.years
  end

  validates_format_of :email, with: /^.+@.+\..+$/, allow_blank: true
  validates_format_of :website,
    with: /^((http|https):\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.?[a-z]{2,5}((:[0-9]{1,5})?\/.*)?$/ix,
    allow_blank: true
  validates_format_of :blog,
    with: /^((http|https):\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.?[a-z]{2,5}((:[0-9]{1,5})?\/.*)?$/ix,
    allow_blank: true

  validates_presence_of :password, on: :update, if: :claim_code_changed?

  validates_presence_of :email, on: :update
  validates_uniqueness_of :email, allow_blank: true

  has_many :vurls, order: 'created_at DESC', include: :clicks

  before_validation_on_create :set_default_password
  before_create :generate_api_token,
                :generate_claim_code,
                :set_default_name

  def claimed?
    claim_code.blank?
  end

  def claim(attrs)
    update_attributes(attrs.merge(claim_code: nil))
  end

  def unclaimed?
    !claimed?
  end

  def has_vurls?
    vurls.any?
  end

  def number_of_vurls
    vurls.count
  end

  def generate_api_token
    self.api_token = new_hash.first(8)
  end

  def self.new_hash
    Digest::SHA1.hexdigest(Time.now.to_s + (rand * 10_000).to_s)
  end

  def new_hash
    self.class.new_hash
  end

  private

  def set_default_name
    self.name = 'Anonymous' if name.blank?
  end

  def generate_claim_code
    self.claim_code = new_hash.first(8)
  end

  def set_default_password
    self.password = new_hash.first(8) unless crypted_password.present? || password.present?
  end
end
