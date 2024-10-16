require 'iqvoc/environments/development'

if Iqvoc::SKOSXL.const_defined?(:Application)
  Iqvoc::SKOSXL::Application.configure do
    # Settings specified here will take precedence over those in config/environment.rb
    Iqvoc::Environments::Development.setup_development(config)
  end
end
