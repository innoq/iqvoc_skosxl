require 'test_helper'
require 'integration_test_helper'

class EditConceptsTest < ActionDispatch::IntegrationTest

  setup do
    @label = FactoryGirl.create(:xllabel)
  end

  test "Create a new concept version" do
    assert @label.published?
    login('administrator')

    visit label_path(@label, :lang => 'de', :format => 'html')
    assert page.has_button?("Neue Version erstellen"), "Button 'Neue Version erstellen' is missing on labels#show"
    click_link_or_button("Neue Version erstellen")
    assert_equal edit_label_path(@label, :lang => 'de', :format => 'html'), current_path

    visit label_path(@label, :lang => 'de', :format => 'html')
    assert !page.has_button?("Neue Version erstellen"), "Button 'Neue Version erstellen' although there already is a new version"
    assert page.has_link?("Vorschau der Version in Bearbeitung"), "Link 'Vorschau der Version in Bearbeitung' is missing"
    click_link_or_button("Vorschau der Version in Bearbeitung")
  end

end
