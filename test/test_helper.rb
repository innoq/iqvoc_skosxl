ENV['RAILS_ENV'] ||= 'test'

# FIXME: needed in integration/label_creation_test for config.eager_load = true at rails boot
Iqvoc::Xllabel.relation_class_names = [
  'Label::Relation::Skosxl::Translation',
  'Label::Relation::Skosxl::UnidirectionalRelation'
]

# Load rails environment if not loaded
unless defined?(Iqvoc) && defined?(Iqvoc::Skosxl) && Iqvoc::Skosxl.const_defined?(:Engine)
  require File.expand_path('../../config/environment', __FILE__)
end

require 'rails/test_help'
