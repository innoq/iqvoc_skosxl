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

  test 'filtering concepts by change note date' do
    login 'administrator'

    visit new_label_path(lang: 'en', format: 'html', published: 0)
    fill_in 'label_value', with: 'Water'
    click_button 'Save'
    click_link_or_button 'Publish'

    visit new_concept_path(lang: 'en', format: 'html', published: 0)
    fill_in 'labeling_skosxl_pref_labels_en', with: Iqvoc::Xllabel.base_class.first.origin
    click_button 'Save'
    click_link_or_button 'Publish'

    visit new_label_path(lang: 'en', format: 'html', published: 0)
    fill_in 'label_value', with: 'Air'
    click_button 'Save'
    click_link_or_button 'Publish'

    visit new_concept_path(lang: 'en', format: 'html', published: 0)
    fill_in 'labeling_skosxl_pref_labels_en', with: Iqvoc::Xllabel.base_class.second.origin
    click_button 'Save'
    click_link_or_button 'Publish'

    Note::Annotated::Base.where(predicate: "created").second.update(value: (DateTime.now - 10.days).to_s)

    visit search_path(lang: 'en', format: 'html')
    find('#t').select 'Labels'
    find('#change_note_type').select 'creation date'
    fill_in 'change_note_date_from', with: Date.today
    click_button('Search')

    refute page.find('.search-results').has_content?('Water')
    assert page.find('.search-results').has_content?('Air')
  end

  test 'filtering xl-labels by change note date' do
    apple_label = Iqvoc::Xllabel.base_class.create!(language: 'de', value: 'Apple', origin: 'apple', published_at: Time.now)
    apple_label.note_skos_change_notes.create!(language: 'de').tap do |note|
      note.annotations.create!(namespace: 'dct', predicate: 'creator', value: 'Arnulf Beckenbauer')
      note.annotations.create!(namespace: 'dct', predicate: 'created', value: '2017-06-01')
    end

    banana_label = Iqvoc::Xllabel.base_class.create!(language: 'de', value: 'Banana', origin: 'banana', published_at: Time.now)
    banana_label.note_skos_change_notes.create!(language: 'de').tap do |note|
      note.annotations.create!(namespace: 'dct', predicate: 'creator', value: 'Arnulf Beckenbauer')
      note.annotations.create!(namespace: 'dct', predicate: 'modified', value: '2017-06-10')
    end

    peach_label = Iqvoc::Xllabel.base_class.create!(language: 'de', value: 'Peach', origin: 'peach', published_at: Time.now)
    peach_label.note_skos_change_notes.create!(language: 'de').tap do |note|
      note.annotations.create!(namespace: 'dct', predicate: 'creator', value: 'Arnulf Beckenbauer')
      note.annotations.create!(namespace: 'dct', predicate: 'created', value: '2017-06-11')
    end

    visit search_path(lang: 'en', format: 'html')
    find('#t').select 'XL Labels'

    # should find Apple and Banana labels
    fill_in 'change_note_date_from', with: '2017-06-01'
    fill_in 'change_note_date_to', with: '2017-06-10'
    click_button('Search')
    assert_equal 2, page.find('ul.search-results').all('li').count
    assert page.find('.search-results').has_content?('Apple')
    assert page.find('.search-results').has_content?('Banana')
    refute page.find('.search-results').has_content?('Peach')

    # should find Apple label
    fill_in 'change_note_date_from', with: '2017-06-01'
    fill_in 'change_note_date_to', with: '2017-06-02'
    click_button('Search')
    page.has_content? 'Search results (1)'
    assert_equal 1, page.find('ul.search-results').all('li').count
    assert page.find('.search-results').has_content?('Apple')
    refute page.find('.search-results').has_content?('Banana')
    refute page.find('.search-results').has_content?('Peach')

    # should find Banana label
    fill_in 'change_note_date_from', with: '2017-06-10'
    fill_in 'change_note_date_to', with: '2017-06-10'
    click_button('Search')
    assert_equal 1, page.find('ul.search-results').all('li').count
    assert page.find('.search-results').has_content?('Banana')
    refute page.find('.search-results').has_content?('Apple')
    refute page.find('.search-results').has_content?('Peach')

    # should find Apple & Peach label (the only ones with created change note)
    fill_in 'change_note_date_from', with: '2017-06-01'
    fill_in 'change_note_date_to', with: '2017-07-01'
    find('#change_note_type').select 'creation date'
    click_button('Search')
    assert_equal 2, page.find('ul.search-results').all('li').count
    assert page.find('.search-results').has_content?('Apple')
    assert page.find('.search-results').has_content?('Peach')
    refute page.find('.search-results').has_content?('Banana')
  end

end
