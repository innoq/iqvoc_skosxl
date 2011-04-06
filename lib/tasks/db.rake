namespace :iqvoc_skosxl do
  namespace :db do
    
    desc "Do iQvoc SKOSXL specific migrations (task is idempotent)"
    task :install_extensions => :environment do
      require Iqvoc::SKOSXL::Engine.find_root_with_flag("db").join('db/migrations/add_skosxl_extensions.rb')
      AddSKOSXLExtensions.up
    end

    desc "Undo iQvoc SKOSXL specific migrations (task is idempotent)"
    task :uninstall_extenstions => :environment do
      require Iqvoc::SKOSXL::Engine.find_root_with_flag("db").join('db/migrations/add_skosxl_extensions.rb')
      AddSKOSXLExtensions.down
    end

    desc "Load seeds (task is idempotent)"
    task :seeds => :environment do
      Iqvoc::SKOSXL::Engine.load_seed
    end

  end
end