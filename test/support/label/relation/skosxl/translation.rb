module Label
  module Relation
    module Skosxl
      class Translation < Label::Relation::Skosxl::Base
        def self.bidirectional?
          true
        end
      end
    end
  end
end
