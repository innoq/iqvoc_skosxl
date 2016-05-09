module Label
  module SKOSXL
    module Validations
      extend ActiveSupport::Concern

      included do
        validates :origin, presence: true
        validates :origin, uniqueness: { scope: :rev }
        validate :origin_has_to_be_escaped

        validate :pref_label_language, if: :validatable_for_publishing?
        validates :value, presence: true, if: :validatable_for_publishing?
      end

      def origin_has_to_be_escaped
        unless Origin.new(origin).valid?
          errors.add :base, I18n.t('txt.models.label.origin_invalid')
        end
      end

      def pref_label_language
        if language != Iqvoc::Concept.pref_labeling_languages.first.to_s && concepts_for_labeling_class(Iqvoc::Concept::pref_labeling_class).any?
          errors.add :base, I18n.t('txt.models.label.pref_label_language')
        end
      end

    end
  end
end
