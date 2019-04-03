source 'https://rubygems.org'

gem 'iqvoc', '~> 4.12', github: 'innoq/iqvoc', branch: 'master'

platforms :ruby do
  gem 'mysql2', '~> 0.4.0'
  gem 'sqlite3'
  gem 'pg'
end

platforms :jruby do
  gem 'activerecord-jdbcsqlite3-adapter'
  gem 'activerecord-jdbcmysql-adapter'
  gem 'activerecord-jdbcpostgresql-adapter', '~> 1.3.13'
end

group :development, :test do
  gem 'quiet_assets'
  gem 'awesome_print'
  gem 'pry-rails', require: 'pry'
end

group :test do
  gem 'capybara'
  gem 'poltergeist', '~> 1.5.0'
end
