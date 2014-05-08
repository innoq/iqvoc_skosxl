source 'https://rubygems.org'

gem 'iqvoc', '~> 4.4.0', :github => 'innoq/iqvoc', :branch => 'async_export'

group :development, :test do
  gem 'awesome_print'
  gem 'spring'
  gem 'pry-rails'

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
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'webmock'
end
