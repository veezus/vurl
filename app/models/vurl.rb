class Vurl < ActiveRecord::Base
  require 'open-uri'
  require 'nokogiri'

  belongs_to :user
  has_many :clicks

  validates_presence_of :url, :user
  validates_format_of   :url, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix
  validate :appropriateness_of_url

  before_validation :format_url
  before_create :set_slug
  before_save :fetch_url_data

  named_scope :most_popular, lambda {|*args| { :order => 'clicks_count desc', :limit => args.first || 5 } }
  named_scope :since, lambda {|*args| { :conditions => ["created_at >= ?", args.first || 7.days.ago] } }

  class << self
    def random
      find(:first, :offset => (Vurl.count * rand).to_i)
    end

    def tweet_most_popular_of_the_day
      require 'twitter'

      vurl = find(:first, :order => 'clicks_count desc', :conditions => ['created_at >= ?', 1.day.ago])
      return if vurl.nil?

      intro = 'Most popular vurl today? '
      link = ' http://vurl.me/' + vurl.slug
      description_length = 140 - intro.length - link.length
      description = vurl.title.first(description_length) unless vurl.title.blank?

      httpauth = Twitter::HTTPAuth.new(APP_CONFIG[:twitter][:login], APP_CONFIG[:twitter][:password], :ssl => true)
      base = Twitter::Base.new(httpauth)
      base.update("#{intro}#{description}#{link}")
    end
  end

  def last_sixty_minutes(start_time=Time.now)
    minutes = []
    60.times do |i|
      new_time = i.minutes.ago(start_time)
      minutes << new_time.change(:hour => new_time.hour, :min => new_time.min)
    end
    minutes.reverse
  end

  def last_twenty_four_hours(start_time=Time.now)
    hours = []
    24.times do |i|
      new_time = i.hours.ago(start_time)
      hours << new_time.change(:hour => new_time.hour)
    end
    hours.reverse
  end

  def last_seven_days(start_date=Time.now)
    dates = []
    7.times do |i|
      new_date = i.days.ago(start_date)
      dates << new_date.change(:hour => 0)
    end
    dates.reverse
  end

  def clicks_for_last period
    case period
    when 'hour'
      clicks.since(1.hour.ago).all(:select => 'clicks.*, MINUTE(clicks.created_at) AS minute').group_by(&:minute)
    when 'day'
      clicks.since(1.day.ago).all(:select => 'clicks.*, HOUR(clicks.created_at) AS hour').group_by(&:hour)
    when 'week'
      clicks.since(1.week.ago).all(:select => 'clicks.*, DAY(clicks.created_at) AS day').group_by(&:day)
    end
  end

  def units_for_last period
    case period
    when 'hour'
      last_sixty_minutes
    when 'day'
      last_twenty_four_hours
    when 'week'
      last_seven_days
    end
  end

  def last_click
    clicks.last
  end

  private

  def fetch_url_data
    begin
      document = Nokogiri::HTML(open(construct_url))

      self.title = document.at('title').text
      self.keywords = document.at("meta[@name*=eywords]/@content").to_s
      self.description = document.at("meta[@name*=escription]/@content").to_s
      truncate_metadata
    rescue
      logger.warn "Could not fetch data for #{construct_url}."
    end
  end

  def construct_url
    url
  end

  def set_slug
    if vurl = Vurl.find(:first, :order => 'id DESC')
      self.slug = vurl.slug.succ
    else
      self.slug = 'AA'
    end
  end

  def format_url
    self.url = url.strip unless url.nil?
  end

  def truncate_metadata
    self.title = title.first(255) if title.length > 255
    self.description = description.first(255) if description.length > 255
    self.keywords = keywords.first(255) if keywords.length > 255
  end

  def appropriateness_of_url
    if url =~ /https*:\/\/[a-zA-Z-]*\.*vurl\.me/i
      errors.add(:url, "shouldn't point back to vurl.me")
    end
  end
end
