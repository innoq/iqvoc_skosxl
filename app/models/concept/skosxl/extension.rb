module Concept
  module SKOSXL
    module Extension

      extend ActiveSupport::Concern

      included do

        after_save do |concept|
          # Labelings
          (@labelings_by_id ||= {}).each do |labeling_relation_name, origin_mappings|
            # Remove all associated labelings of the given type
            concept.send(labeling_relation_name).destroy_all

            # (Re)create labelings reflecting a widget's parameters
            origin_mappings.each do |language, new_origins|
              new_origins = new_origins.split(/[,\n]/).map(&:squish)

              # Iterate over all labels to be added and create them
              Iqvoc::XLLabel.base_class.by_origin(new_origins).each do |l|
                concept.send(labeling_relation_name).create!(:target => l)
              end
            end
          end

        end

      end

      module InstanceMethods

        def labelings_by_id=(hash)
          @labelings_by_id = hash
        end

        def labelings_by_id(relation_name, language)
          (@labelings_by_id && @labelings_by_id[relation_name] && @labelings_by_id[relation_name][language]) ||
            self.send(relation_name).by_label_language(language).map{ |l| l.target.origin }.join(",")
        end

      end
      
    end
  end
end