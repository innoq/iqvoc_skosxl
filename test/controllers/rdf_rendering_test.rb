require File.join(File.expand_path(File.dirname(__FILE__)), '../test_helper')

class RdfRenderingTest < ActionController::TestCase
    setup do
      @label = Iqvoc::Xllabel.base_class.create(
          language: 'en', value: 'Forest', origin: 'forest', published_at: 3.days.ago)

    end

  test 'label representations' do
    @controller = RdfController.new

    get :show, params: { lang: 'en', id: @label.origin, format: 'ttl' }
    assert_response 200
    assert @response.body.include? '@prefix skosxl: <http://www.w3.org/2008/05/skos-xl#>.'
    assert @response.body.include? ':forest a skosxl:Label'
    assert @response.body.include? 'skosxl:literalForm "Forest"@en'
  end
end
