module Label
  module SKOSXL
    module Validations
      extend ActiveSupport::Concern

      included do
        validates :origin, presence: true
        validates :origin, uniqueness: { scope: :rev }
        validate :origin_has_to_be_escaped

        validates :value, uniqueness: { scope: [:language, :rev] },
                          if: :validatable_for_publishing?
        validates :value, presence: true, if: :validatable_for_publishing?
      end

      def origin_has_to_be_escaped
        unless Origin.new(origin).valid?
          errors.add :base, I18n.t('txt.models.label.origin_invalid')
        end
      end

    end
  end
end
