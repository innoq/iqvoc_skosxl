require 'rails'

module Iqvoc
  module Skosxl
    class Engine < Rails::Engine
      paths['lib/tasks'] << 'lib/engine_tasks'

      initializer 'iqvoc_skosxl.load_migrations' do |app|
        app.config.paths['db/migrate'].concat(Iqvoc::Skosxl::Engine.paths['db/migrate'].existent)
      end
    end
  end
end
