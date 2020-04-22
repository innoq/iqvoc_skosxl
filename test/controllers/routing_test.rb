# encoding: UTF-8

require File.join(File.expand_path(File.dirname(__FILE__)), '../test_helper')

class RoutingTest < ActionController::TestCase
  setup do
    @controller = LabelsController.new
    @label = Iqvoc::XLLabel.base_class.create value: 'foo',
        language: 'en', published_at: Time.now
  end

  test 'routing' do
    get :show, params: {
      lang: 'en',
      format: 'html',
      id: @label.origin
    }
    assert_response :success
  end
end
