source 'https://rubygems.org'

gem 'iqvoc', '~> 4.15.0', github: 'innoq/iqvoc', branch: :main

platforms :ruby do
  gem 'pg'
end

group :development do
  gem 'web-console'
  gem 'listen'
end

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]
end

group :test do
  gem 'capybara'
  gem 'cuprite'
  gem 'minitest', '< 6'
end
