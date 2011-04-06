require 'rails'

module Iqvoc
  module SKOSXL

    class Engine < Rails::Engine
      
      ActiveSupport.on_load(:after_iqvoc_config) do
        require(Rails.root.join('lib/iqvoc.rb'))
        require 'iqvoc/skosxl/ability'
        
        Iqvoc.ability_class_name = "Iqvoc::SKOSXL::Ability"

        Iqvoc.default_rdf_namespace_helper_methods << :iqvoc_skosxl_default_rdf_namespaces

        Iqvoc::Concept.pref_labeling_class_name     = 'Labeling::SKOSXL::PrefLabeling'
        Iqvoc::Concept.pref_labeling_languages      = [ :en ]
        Iqvoc::Concept.further_labeling_class_names = { 
          'Labeling::SKOSXL::AltLabel' => [ :de, :en ]
        }

  #   TODO     Iqvoc.searchable_class_names = Iqvoc::Concept.labeling_class_names.keys + Iqvoc::Concept.note_class_names
      end

      def self.load_seed
        seed_file = Iqvoc::SKOSXL::Engine.find_root_with_flag("db").join('db/seeds.rb')
        load(seed_file) if File.exist?(seed_file)
      end

    end
    
  end
end
