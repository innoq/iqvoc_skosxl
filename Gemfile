source "http://rubygems.org"

gem 'rails', '3.2.3'
gem 'iqvoc', '~> 3.5.5'

group :development do
  gem 'awesome_print'
end

group :assets do
  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
  platforms :ruby do
    gem 'mysql2'
    gem 'sqlite3'
  end
  platforms :jruby do
    gem 'activerecord-jdbcsqlite3-adapter'
    gem 'activerecord-jdbcmysql-adapter'
  end
end

group :test do
  gem 'test-unit'
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
