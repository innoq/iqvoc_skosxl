module Concept
  module SKOSXL
    module Extension
      extend ActiveSupport::Concern

      included do
        validate :valid_label_language

        before_validation do |concept|
          # Labelings
          (@labelings_by_id ||= {}).each do |labeling_relation_name, origin_mappings|
            # Remove all associated labelings of the given type
            concept.send(labeling_relation_name).destroy_all
          end
        end

        after_save do |concept|
          (@labelings_by_id ||= {}).each do |labeling_relation_name, origin_mappings|
            # (Re)create labelings reflecting a widget's parameters
            origin_mappings.each do |language, new_origins|
              new_origins = new_origins.
                  split(InlineDataHelper::SPLITTER).map(&:squish)

              # Iterate over all labels to be added and create them
              Iqvoc::XLLabel.base_class.by_origin(new_origins).each do |l|
                concept.send(labeling_relation_name).create!(target: l)
              end
            end
          end
        end
      end

      def class_path
        'concept_path'
      end

      def labelings_by_id=(hash)
        @labelings_by_id = hash
      end

      def labelings_by_id(relation_name, language)
        (@labelings_by_id && @labelings_by_id[relation_name] && @labelings_by_id[relation_name][language]) ||
          self.send(relation_name)
              .by_label_language(language)
              .map { |l| l.target.origin }
              .join(InlineDataHelper::JOINER)
      end

      def valid_label_language
        (@labelings_by_id || {}).each { |labeling_class_name, origin_mappings|
          origin_mappings.each { |language, new_origins|
            new_origins = new_origins.split(InlineDataHelper::SPLITTER)
            Iqvoc::XLLabel.base_class.by_origin(new_origins).published.each do |label|
              if label.language != language.to_s
                errors.add(:base,
                    I18n.t('txt.controllers.versioned_concept.label_error') % label)
              end
            end
          }
        }
      end
    end
  end
end
