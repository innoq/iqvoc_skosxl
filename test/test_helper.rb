ENV['RAILS_ENV'] ||= 'test'

# Load rails environment if not loaded
unless defined?(Iqvoc) && defined?(Iqvoc::SKOSXL) && Iqvoc::SKOSXL.const_defined?(:Engine)
  require File.expand_path('../../config/environment', __FILE__)
end

require 'rails/test_help'
