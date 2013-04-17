source "http://rubygems.org"

gem 'rails', '~> 3.2.13'
gem 'iqvoc', :git => 'git://github.com/innoq/iqvoc.git'

group :development do
  gem 'awesome_print'
end

group :assets do
  gem 'uglifier',   '>= 1.0.3'
  gem 'sass-rails', '~> 3.2.5'
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

    gem 'pry'
    gem 'pry-rails'
    gem 'pry-debugger'
    gem 'pry-remote'
    gem 'hirb-unicode'
    gem 'cane'
  end

  platforms :jruby do
    gem 'activerecord-oracle_enhanced-adapter'
  end
end
