# encoding: UTF-8

# Copyright 2011-2017 innoQ Deutschland GmbH
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

class DuplicateLabelTest < ActionDispatch::IntegrationTest
  setup do
    @label = Iqvoc::XLLabel.base_class.create(
      language: 'de', value: 'Wald', published_at: 3.days.ago)
  end

  test 'Duplicate a label' do
    assert @label.published?
    login('administrator')

    visit label_path(@label, lang: 'de', format: 'html')
    assert page.has_link?('Duplizieren')
    click_link_or_button('Duplizieren')
    assert_equal label_duplicate_path(@label, lang: 'de', format: 'html'), current_path

    click_link_or_button('Speichern')

    assert !page.has_button?('Neue Version erstellen')
    assert !page.has_link?('Duplizieren')
    assert page.has_button?('Veröffentlichen')
    assert page.has_content? 'Das Label wurde aktualisiert.'
    assert page.has_content? 'Wald [Kopie]'

    # check initial created-ChangeNote
    change_note_relation_name = Iqvoc::change_note_class_name.to_relation_name
    within("\##{change_note_relation_name}") do
      assert page.has_css?('.translation', count: 1)
      assert page.has_content? 'Initiale Version'
      assert page.has_content? 'dct:created'
    end

  end

end
