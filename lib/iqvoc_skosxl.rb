module IqvocSKOSXL

  require File.join(File.dirname(__FILE__), '../config/engine') unless Iqvoc.const_defined?(:SKOSXL) && Iqvoc::SKOSXL.const_defined?(:Application)

  ActiveSupport.on_load(:after_iqvoc_config) do
    require 'iqvoc'

    Iqvoc.config do |cfg|
      prefix = "languages.further_labelings."
      cfg.deregister_setting("#{prefix}Labeling::SKOS::AltLabel") # iQvoc core default
      cfg.register_settings({
        "title" => "iQvoc SKOS-XL",
        "#{prefix}Labeling::SKOSXL::AltLabel" => ["en", "de"]
      })
    end

    Iqvoc.rdf_namespaces[:skosxl] = "http://www.w3.org/2008/05/skos-xl#" unless Iqvoc.rdf_namespaces[:skosxl]

    Iqvoc.default_rdf_namespace_helper_methods << :iqvoc_skosxl_default_rdf_namespaces

    Iqvoc::Concept.include_module_names << "Concept::SKOSXL::Extension"

    Iqvoc::Concept.pref_labeling_class_name = 'Labeling::SKOSXL::PrefLabel'

    #   TODO     Iqvoc.searchable_class_names = Iqvoc::Concept.labeling_class_names.keys + Iqvoc::Concept.note_class_names
  end

end
