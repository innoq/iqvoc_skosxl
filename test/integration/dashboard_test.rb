require 'test_helper'
require 'integration_test_helper'

class DashboardTest < ActionDispatch::IntegrationTest

  setup do
    @label = FactoryGirl.create(:xllabel, :published_at => nil)
  end

  test "labels appearing in dashboard" do
    assert !@label.published?
    login('administrator')

    visit dashboard_path(:lang => 'de', :format => 'html')
    assert page.has_link?(@label.value.to_s), "Couldn't find Label link '#{@label.value.to_s}' in dashboards concepts + labels list"
    click_link_or_button(@label.value.to_s)
    assert_equal label_path(@label, :lang => 'de', :format => 'html'), current_path
  end

  test "new label link in dashboard" do
    login('administrator')

    visit dashboard_path(:lang => 'de', :format => 'html')
    click_link_or_button("de")
    assert_equal new_label_path(:lang => 'de', :format => 'html'), current_path
  end

end
