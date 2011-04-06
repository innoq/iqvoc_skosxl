source "http://rubygems.org"

gem "iqvoc", :path => '../iqvoc'

gem 'cancan'

group :development do
  gem 'mongrel'
  gem 'awesome_print'
end

group :development, :test do
  platforms :ruby do
    gem 'mysql' # AR Bug
    gem 'mysql2'
  end
  platforms :jruby do
    gem 'activerecord-jdbcmysql-adapter'
  end
end

group :test do
  gem 'nokogiri', '1.4.3.1'
  gem 'capybara'
  # gem 'capybara-envjs'
  gem 'database_cleaner', '0.6.0.rc.3'
  gem 'launchy'    # So you can do Then show me the page
  gem 'factory_girl_rails'
end

group :production, :production_internal do
  platforms :ruby do
    gem 'sqlite3-ruby', :require => 'sqlite3'
  end

  platforms :jruby do
    gem 'activerecord-oracle_enhanced-adapter'
  end
end
