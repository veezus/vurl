class Vurl < ActiveRecord::Base
  require 'open-uri'
  require 'nokogiri'

  belongs_to :user
  has_many :clicks

  validates_presence_of :url, :user
  validates_format_of   :url, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix

  before_validation :format_url
  before_save :fetch_url_data

  named_scope :most_popular, lambda {|*args| { :order => 'clicks_count desc', :limit => args.first || 5 } }
  named_scope :since, lambda {|*args| { :conditions => ["created_at >= ?", args.first || 7.days.ago] } }

  def days_with_clicks
    clicks.map(&:created_at).map(&:to_date).uniq
  end

  def self.random
    find(:first, :offset => (Vurl.count * rand).to_i)
  end

  def before_create
    if vurl = Vurl.find(:first, :order => 'id DESC')
      self.slug = vurl.slug.succ
    else
      self.slug = 'AA'
    end
  end

  def self.tweet_most_popular_of_the_day
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

  private

  def format_url
    self.url = url.strip unless url.nil?
  end

  def truncate_metadata
    self.title = title.first(255) if title.length > 255
    self.description = description.first(255) if description.length > 255
    self.keywords = keywords.first(255) if keywords.length > 255
  end
end
