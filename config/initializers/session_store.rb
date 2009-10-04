# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_goo_session',
  :secret      => '13e61eb336ac569f1c5dfbe54e62f722347ef148acebdc9aed3f5fed234689b60ae5d92cb1d5768e2dbf6f37c6d7777f5f0aaf7a998ed27495b0b45e7a292f8b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
