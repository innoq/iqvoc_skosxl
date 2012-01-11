require 'rails'

module Iqvoc
  module SKOSXL

    class Engine < Rails::Engine

      paths.lib.tasks  << "lib/engine_tasks"

    end

  end
end
