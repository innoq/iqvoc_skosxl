require 'iqvoc/environments/production'

if Iqvoc::SKOSXL.const_defined?(:Application)
  Iqvoc::SKOSXL::Application.configure do
    # Settings specified here will take precedence over those in config/environment.rb
    Iqvoc::Environments.setup_production(config)
  end
end
