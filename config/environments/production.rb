require 'iqvoc/environments/production'

if Iqvoc::Skosxl.const_defined?(:Application)
  Iqvoc::Skosxl::Application.configure do
    # Settings specified here will take precedence over those in config/environment.rb
    Iqvoc::Environments::Production.setup(config)
  end
end
