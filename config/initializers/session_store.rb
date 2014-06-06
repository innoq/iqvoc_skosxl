# Be sure to restart your server when you modify this file.
if Iqvoc::SKOSXL.const_defined?(:Application)
  Iqvoc::SKOSXL::Application.config.session_store :cookie_store, key: '_iqvoc_skosxl_session'
end
# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# Iqvoc::Application.config.session_store :active_record_store
