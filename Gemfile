source 'https://rubygems.org'

gem 'iqvoc', '~> 4.13.0', github: 'innoq/iqvoc', branch: 'rails-6'

platforms :ruby do
  gem 'pg'
end

group :development do
  gem 'better_errors'
  gem 'web-console'
  gem 'listen'
end

group :development, :test do
  gem 'pry-rails', require: 'pry'
  gem 'rack-mini-profiler'
end

group :test do
  gem 'capybara'
  gem 'cuprite'
end
