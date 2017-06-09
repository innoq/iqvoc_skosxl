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

class SearchTest < ActionDispatch::IntegrationTest

  test 'date filter' do
    login 'administrator'

    visit new_label_path(lang: 'en', format: 'html', published: 0)
    fill_in 'label_value', with: 'Water'
    click_button 'Save'
    click_link_or_button 'Publish'

    visit new_concept_path(lang: 'en', format: 'html', published: 0)
    fill_in 'labeling_skosxl_pref_labels_en', with: Iqvoc::XLLabel.base_class.first.origin
    click_button 'Save'
    click_link_or_button 'Publish'

    visit new_label_path(lang: 'en', format: 'html', published: 0)
    fill_in 'label_value', with: 'Air'
    click_button 'Save'
    click_link_or_button 'Publish'

    visit new_concept_path(lang: 'en', format: 'html', published: 0)
    fill_in 'labeling_skosxl_pref_labels_en', with: Iqvoc::XLLabel.base_class.second.origin
    click_button 'Save'
    click_link_or_button 'Publish'

    Note::Annotated::Base.where(predicate: "created").second.update_attributes value: (Date.today - 10.days).to_s

    visit search_path(lang: 'en', format: 'html')
    find('#t').select 'Labels'
    find('#change_note_type').select 'creation date'
    fill_in 'change_note_date_from', with: Date.today
    click_button('Search')

    refute page.find('.search-results').has_content?('Water')
    assert page.find('.search-results').has_content?('Air')
  end

end
