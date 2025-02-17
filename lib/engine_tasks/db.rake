# encoding: UTF-8

namespace :iqvoc_skosxl do
  namespace :db do

    desc "Load seeds (task is idempotent)"
    task :seed => :environment do
      Iqvoc::Skosxl::Engine.load_seed
    end

  end
end
