module Label
  module SKOSXL
    module Validations
      extend ActiveSupport::Concern

      included do
        validates :origin, presence: true
        validates :origin, uniqueness: { scope: :rev }
        validate :origin_has_to_be_escaped

        validates :value, uniqueness: { scope: [:language, :rev] }
        validate :value_must_be_given
      end

      def origin_has_to_be_escaped
        unless Iqvoc::Origin.new(origin).valid?
          errors.add :origin, I18n.t('txt.models.label.origin_invalid')
        end
      end

      def value_must_be_given
        if validatable_for_publishing?
          if value.blank?
            errors.add :origin, I18n.t('txt.models.label.value_error')
          end
        end
      end
    end
  end
end
