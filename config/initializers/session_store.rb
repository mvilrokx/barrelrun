# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_point2wine_session',
  :secret      => 'b283cc5919ddb1d839bfbf2c644714355cabae1b989e0ddcb87f6823e8c13f0701efa7f262a73d54dc0c8aa39e3c9dc6ddea5cac4da2cc20318b66539dd47441'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
