module Collection
  module SKOSXL
    module Extension
      extend ActiveSupport::Concern

      def class_path
        'collection_path'
      end

    end
  end
end
