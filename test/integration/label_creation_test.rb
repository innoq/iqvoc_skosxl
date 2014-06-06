# encoding: UTF-8

# Copyright 2011-2014 innoQ Deutschland GmbH
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

class LabelCreationTest < ActionDispatch::IntegrationTest
  setup do
    login 'administrator'
  end

  test 'label creation' do
    visit new_label_path(lang: 'de', language: 'de')
    assert page.has_content? 'Neues Label'
    fill_in 'Vorlageform', with: 'Testlabel'
    click_link_or_button 'Speichern'
    assert page.has_content? 'Das Label wurde erstellt.'
    click_link_or_button 'Konsistenz prüfen'
    assert page.has_content? 'Instanz ist konsistent.'
  end

  test 'inkonsistent label creation' do
    visit new_label_path(lang: 'de', language: 'de')
    assert page.has_content? 'Neues Label'
    fill_in 'Vorlageform', with: ''
    click_link_or_button 'Speichern'
    assert page.has_content? 'Das Label wurde erstellt.'
    click_link_or_button 'Konsistenz prüfen'
    assert page.has_content? 'Instanz ist inkonsistent.'
  end
end
