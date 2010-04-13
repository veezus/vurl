# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'
if File.dirname(__FILE__).include? 'staging'
  ENV['RAILS_ENV'] = 'staging'
end


# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

config_file_path = File.join(RAILS_ROOT, *%w(config settings.yml))
if File.exist?(config_file_path)
  config = YAML.load_file(config_file_path)
  APP_CONFIG = config.has_key?(RAILS_ENV) ? config[RAILS_ENV] : {}
else
  puts "WARNING: configuration file #{config_file_path} not found."
  APP_CONFIG = {}
end

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use (only works if using vendor/rails).
  # To use Rails without a database, you must remove the Active Record framework
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_vurl_session',
    :secret      => '176424d37789192152a4757bd076fb8980abb71610602ec532fa6703e2ffbb2fcfe4c29555cbf1f97bc422d0d85e7a4835747f6faa1ce62f6ac1626dea6cae12'
  }

  config.gem 'haml', :version => '2.2.6'
  config.gem 'newrelic_rpm', :version => '2.9.8'
  config.gem 'sitemap_generator', :version => '0.2.2', :lib => false

  #For TEST Environment
  config.gem 'factory_girl', :lib => false, :version => '1.2.4'
  config.gem 'rspec-rails', :lib => false, :version => '1.3.2'
  config.gem 'shoulda', :version => '2.10.3', :lib => false
  config.gem 'webrat', :version => '>= 0.5.3', :lib => false

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
end
