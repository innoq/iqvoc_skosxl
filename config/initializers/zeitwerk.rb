# FIXME: custom auto loading inflections due class naming inconsistencies with acronyms
if Rails.autoloaders.zeitwerk_enabled?
  Rails.autoloaders.main.inflector.inflect(
    'skosxl' => 'SKOSXL',
    'xllabel' => 'XLLabel'
  )
end
