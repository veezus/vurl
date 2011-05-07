# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  key:    '_vurl_session',
  secret: '02d09f452848a266dd5f389e8fa9e75477275aa1b956ce55e0779c12dbcdc9004849ac8df9f70d45225477ba7acc58892d4e2c91482dda181ea74c42ed47a307'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
