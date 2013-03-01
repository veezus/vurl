class Vurl < ActiveRecord::Base
  require 'nokogiri'

  state_machine :status, initial: :nominal do
    event :flag_as_spam do
      transition nominal: :flagged_as_spam
    end
  end

  has_many :clicks
end
