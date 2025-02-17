module Label
  module Skosxl
    module Validations
      extend ActiveSupport::Concern

      included do
        validates :origin, presence: true
        validates :origin, uniqueness: { scope: :rev }
        validate :origin_has_to_be_escaped

        # publishing validations
        validates :value, presence: true, if: :validatable_for_publishing?
        validate :pref_label_language, if: :validatable_for_publishing?
        validate :referenced_published_concepts_have_main_language_pref_label, if: :validatable_for_publishing?
      end

      def origin_has_to_be_escaped
        unless Origin.new(origin).valid?
          errors.add :base, I18n.t('txt.models.label.origin_invalid')
        end
      end

      def pref_label_language
        invalid_pref_label_language = ::Iqvoc::Concept.pref_labeling_languages.exclude?(language)
        has_pref_labeled_concepts = concepts_for_labeling_class(::Iqvoc::Concept.pref_labeling_class).any?

        if invalid_pref_label_language && has_pref_labeled_concepts
          errors.add :base, I18n.t('txt.models.label.pref_label_language')
        end
      end

      def referenced_published_concepts_have_main_language_pref_label
        published_label = self.published_version

        # check published concepts which use the current label as a pref label
        concepts.published.each do |concept|
          # pref labels without the current published one
          pref_labels = concept.pref_labels.reject { |l| l == published_label }

          unless pref_labels.map(&:language).map(&:to_s).include?(::Iqvoc::Concept.pref_labeling_languages.first.to_s)
            errors.add :base, I18n.t('txt.models.label.referenced_concepts_invalid')
          end
        end
      end

    end
  end
end
