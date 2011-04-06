module IqvocSKOSXL
  require File.join(File.dirname(__FILE__), '../config/engine') unless Iqvoc.const_defined?(:SKOSXL) && Iqvoc::SKOSXL.const_defined?(:Application)

  ActiveSupport.on_load(:after_iqvoc_config) do
    require('iqvoc')
 
    Iqvoc.rdf_namespaces[:skosxl] = "http://www.w3.org/2008/05/skos-xl#" unless Iqvoc.rdf_namespaces[:skosxl]

    Iqvoc.default_rdf_namespace_helper_methods << :iqvoc_skosxl_default_rdf_namespaces

    Iqvoc::Concept.pref_labeling_class_name = 'Labeling::SKOSXL::PrefLabel'
    Iqvoc::Concept.further_labeling_class_names = {
      'Labeling::SKOSXL::AltLabel' => [ :de, :en ]
    }

    #   TODO     Iqvoc.searchable_class_names = Iqvoc::Concept.labeling_class_names.keys + Iqvoc::Concept.note_class_names
  end

end
