source "http://rubygems.org"

gem 'rails', '3.1.3'
gem 'iqvoc', :path => '../iqvoc'

# Hotfix for the problem of engine/plugin helpers not being mixed in.
# https://rails.lighthouseapp.com/projects/8994/tickets/1905-apphelpers-within-plugin-not-being-mixed-in
# http://github.com/drogus/rails_helpers_fix
gem 'rails_helpers_fix'

group :development do
  gem 'awesome_print'
end

group :development, :test do
  platforms :ruby do
    gem 'mysql2'
  end
  platforms :jruby do
    gem 'activerecord-jdbcmysql-adapter'
  end
end

group :test do
  gem 'memory_test_fix'
  gem 'nokogiri', '~> 1.5.0'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
end

group :production, :production_internal do
  platforms :ruby do
    gem 'sqlite3'
  end

  platforms :jruby do
    gem 'activerecord-oracle_enhanced-adapter'
  end
end
