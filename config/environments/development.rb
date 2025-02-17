require 'iqvoc/environments/development'

if Iqvoc::Skosxl.const_defined?(:Application)
  Iqvoc::Skosxl::Application.configure do
    # Settings specified here will take precedence over those in config/environment.rb
    Iqvoc::Environments::Development.setup(config)
  end
end
