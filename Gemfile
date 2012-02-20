# Environment Variables:
#
# IQVOC_EDGE
#   determines whether development versions of iQvoc dependencies are used
#   if "local", `:path` is used when resolving gem source
#   if "remote", `:git` is used when resolving gem source
#
# based on https://gist.github.com/1857044

source "http://rubygems.org"

# avoid modifying default Gemfile.lock in development mode
ENV["BUNDLE_GEMFILE"] ||= "Gemfile.dev" if ENV["IQVOC_EDGE"]

def iqvoc_gem(name, version, sources)
  if edge = ENV["IQVOC_EDGE"]
    options = {}
    case edge
    when "local"
      options[:path] = sources[:path]
    when "remote"
      options[:git] = sources[:git]
    else
      raise ArgumentError, "invalid source `#{edge}` for #{name}"
    end
  end

  gem name, version, options
end

gem 'rails', '3.2.1'
iqvoc_gem 'iqvoc', '~> 3.5.1',
    :path => '../iqvoc',
    :git => 'git://github.com/innoq/iqvoc.git'

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
    gem 'activerecord-jdbcsqlite-adapter'
    gem 'activerecord-jdbcmysql-adapter'
  end
end

group :test do
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
