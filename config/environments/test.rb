require 'iqvoc/environments/test'

if Iqvoc::Skosxl.const_defined?(:Application)
  Iqvoc::Skosxl::Application.configure do
    # Settings specified here will take precedence over those in config/environment.rb
    Iqvoc::Environments::Test.setup(config)
  end
end
