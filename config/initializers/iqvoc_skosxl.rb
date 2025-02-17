require 'iqvoc/xllabel'

if Rails.env.test?
  # FIXME: needed in tests for config.eager_load = true at rails boot
  # move somewhere to test/
  Iqvoc::Xllabel.relation_class_names = [
    'Label::Relation::Skosxl::Translation',
    'Label::Relation::Skosxl::UnidirectionalRelation'
  ]
end
