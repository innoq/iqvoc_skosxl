# encoding: UTF-8

# Copyright 2011 innoQ Deutschland GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require File.join(File.expand_path(File.dirname(__FILE__)), '../integration_test_helper')

class DashboardTest < ActionDispatch::IntegrationTest
  setup do
    @label = Iqvoc::XLLabel.base_class.create(
      language: 'en', value: 'Forest', published_at: nil)
  end

  test 'labels appearing in dashboard' do
    assert !@label.published?
    login('administrator')

    visit label_dashboard_path(lang: 'de', format: 'html')
    assert page.has_link?(@label.value.to_s), "Couldn't find Label link '#{@label.value.to_s}' in dashboards concepts + labels list"
    click_link_or_button(@label.value.to_s)
    assert_equal label_path(@label, lang: 'de', format: 'html'), current_path
  end

  test 'new label link in dashboard' do
    login('administrator')

    visit dashboard_path(lang: 'de', format: 'html')
    click_link_or_button('Neues Label')
    assert_equal new_label_path(lang: 'de', format: 'html'), current_path
  end
end
