# encoding: UTF-8

if Iqvoc::SKOSXL.const_defined?(:Application)
  namespace :db do

    task :migrate_all => :environment do
      Iqvoc.invoke_engine_tasks "db:migrate", %w(iqvoc)
    end

    task :seed_all => :environment do
      Iqvoc.invoke_engine_tasks "db:seed", %w(iqvoc)
    end

  end
end
