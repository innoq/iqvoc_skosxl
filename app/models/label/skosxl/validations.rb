module Label
  module SKOSXL
    module Validations
      extend ActiveSupport::Concern

      included do
        validates :origin, presence: true

        validate :origin_has_to_be_escaped
        validate :value_must_be_given
      end

      def origin_has_to_be_escaped
        if origin != Iqvoc::Origin.new(origin).to_s
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
