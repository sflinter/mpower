# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_mpower_session',
  :secret      => '6d9a513df161745e19c4d2072805bd5e84ee45db821fd5cbed1047108ab027109d8abdb996a868979ff28f88cad7253a85559b0260848f0d984ceaf58a3826f7'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
