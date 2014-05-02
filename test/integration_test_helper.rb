require 'capybara/rails'
require 'capybara/dsl'
require 'test_helper'
require Iqvoc::Engine.root.join('test', 'authentication')

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Authentication
end
