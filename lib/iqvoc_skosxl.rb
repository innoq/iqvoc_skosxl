require 'iqvoc/xllabel'
require 'iqvoc/skosxl/version'

module IqvocSkosxl
  unless Iqvoc.const_defined?(:Skosxl) && Iqvoc::Skosxl.const_defined?(:Application)
    require File.join(File.dirname(__FILE__), '../config/engine')
  end

  ActiveSupport.on_load(:after_iqvoc_config) do
    require 'iqvoc'

    Iqvoc.config do |cfg|
      prefix = 'languages.further_labelings.'
      cfg.deregister_setting("#{prefix}Labeling::Skos::AltLabel") # iQvoc core default
      cfg.deregister_setting("#{prefix}Labeling::Skos::HiddenLabel") # iQvoc core default
      cfg.register_settings({
        'title' => 'iQvoc SKOS-XL',
        "#{prefix}Labeling::Skosxl::AltLabel" => ['en', 'de'],
        "#{prefix}Labeling::Skosxl::HiddenLabel" => ['en', 'de'],
        "label_duplicate_check_mode" => "contains"
      })
    end

    unless Iqvoc.rdf_namespaces[:skosxl]
      Iqvoc.rdf_namespaces[:skosxl] = 'http://www.w3.org/2008/05/skos-xl#'
    end

    Iqvoc::Concept.include_module_names << 'Concept::Skosxl::Extension'
    Iqvoc::Concept.pref_labeling_class_name = 'Labeling::Skosxl::PrefLabel'
    Iqvoc::Concept.alt_labeling_class_name = 'Labeling::Skosxl::AltLabel'
    Iqvoc::Concept.hidden_labeling_class_name = 'Labeling::Skosxl::HiddenLabel'

    Iqvoc::Collection.include_module_names << 'Collection::Skosxl::Extension'
    Iqvoc::Collection.pref_labeling_class_name = 'Labeling::Skosxl::PrefLabel'
    Iqvoc::Collection.alt_labeling_class_name = 'Labeling::Skosxl::AltLabel'
    Iqvoc::Collection.hidden_labeling_class_name = 'Labeling::Skosxl::HiddenLabel'

    # TODO
    # Iqvoc.searchable_class_names = Iqvoc::Concept.labeling_class_names.keys +
    #    Iqvoc::Concept.note_class_names
  end
end
