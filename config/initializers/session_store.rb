# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_kittencannon_session',
  :secret      => 'fa699c18979d666c27747c035cf4ef7a5e7432ed0abce9ba0da566d0efe632759ea1e26276c6b77feaa71e531d8da1e2fd33edff21ac2c83ba8fec3fa3eacc06'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
