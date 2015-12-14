module Label
  module SKOSXL
    module Validations
      extend ActiveSupport::Concern

      included do
        validates :origin, presence: true
        validates :origin, uniqueness: { scope: :rev }
        validate :origin_has_to_be_escaped

        validate :referenced_published_concepts_has_to_be_valid, if: :validatable_for_publishing?
        validates :value, uniqueness: { scope: [:language, :rev] },
          if: :validatable_for_publishing?
        validates :value, presence: true, if: :validatable_for_publishing?
      end

      def origin_has_to_be_escaped
        unless Origin.new(origin).valid?
          errors.add :base, I18n.t('txt.models.label.origin_invalid')
        end
      end

      def referenced_published_concepts_has_to_be_valid
        published_label = self.published_version

        # check published concepts which use the current label as a pref label
        concepts.published.each do |concept|
          # pref labels without the current published one
          labels = concept.pref_labels.reject{ |l| l == published_label }

          unless labels.map(&:language).map(&:to_s).include?(::Iqvoc::Concept.pref_labeling_languages.first.to_s)
            errors.add :base, I18n.t('txt.models.label.referenced_concepts_invalid')
          end
        end
      end

    end
  end
end
