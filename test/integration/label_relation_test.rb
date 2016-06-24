# encoding: UTF-8

# Copyright 2011-2016 innoQ Deutschland GmbH
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

class LabelsRelationTest < ActionDispatch::IntegrationTest

  # sample bidirectional relation
  module Label::Relation::SKOSXL
    class Translation < Label::Relation::SKOSXL::Base
      def self.bidirectional?
        true
      end
    end

    class UnidirectionalRelation < Label::Relation::SKOSXL::Base
    end
  end

  # add label relation to iqvoc initializer
  Iqvoc::XLLabel.relation_class_names = [
    'Label::Relation::SKOSXL::Translation',
    'Label::Relation::SKOSXL::UnidirectionalRelation'
  ]

  setup do
    @dog_en = Iqvoc::XLLabel.base_class.create!(
      language: 'en',
      value: 'Dog',
      origin: 'dog_en',
      published_at: Time.now
    )

    @dog_de = Iqvoc::XLLabel.base_class.create!(
      language: 'de',
      value: 'Hund',
      origin: 'dog_de',
      published_at: Time.now
    )

    login('administrator')
  end

  test 'bidirectional label relation assignment' do
    assert @dog_en.label_relation_skosxl_translations.empty?
    assert @dog_de.label_relation_skosxl_translations.empty?

    visit label_path(@dog_en, lang: 'en', format: 'html')
    click_link_or_button('Create new version')
    assert_equal edit_label_path(@dog_en, lang: 'en', format: 'html'), current_path
    assert page.has_content? 'Instance copy has been created and locked.'

    # add translation dog_en => dog_de
    fill_in 'label_relation_skosxl_translations', with: 'dog_de'
    click_link_or_button('Save')

    assert page.has_content? 'Label has been successfully modified.'
    click_link_or_button('Publish')

    # check db relations
    dog_en_with_translation = Iqvoc::XLLabel.base_class.find_by(origin: 'dog_en')
    assert_equal 1, dog_en_with_translation.label_relation_skosxl_translations.size
    assert_equal 'dog_de', dog_en_with_translation.label_relation_skosxl_translations.first.range.origin

    dog_de_with_translation = Iqvoc::XLLabel.base_class.find_by(origin: 'dog_de')
    assert_equal 1, dog_de_with_translation.label_relation_skosxl_translations.size
    assert_equal 'dog_en', dog_de_with_translation.label_relation_skosxl_translations.first.range.origin

    # remove previously added translation
    click_link_or_button('Create new version')
    fill_in 'label_relation_skosxl_translations', with: ''
    click_link_or_button('Save')
    assert page.has_content? 'Label has been successfully modified.'
    click_link_or_button('Publish')

    # check if relations are destroyed
    dog_en_without_translation = Iqvoc::XLLabel.base_class.find_by(origin: 'dog_en')
    assert dog_en_without_translation.label_relation_skosxl_translations.empty?

    dog_de_without_translation = Iqvoc::XLLabel.base_class.find_by(origin: 'dog_de')
    assert dog_de_without_translation.label_relation_skosxl_translations.empty?
  end

  test 'unidirectional label relation assignment' do
    assert @dog_en.label_relation_skosxl_unidirectional_relations.empty?
    assert @dog_de.label_relation_skosxl_unidirectional_relations.empty?

    visit label_path(@dog_en, lang: 'en', format: 'html')
    click_link_or_button('Create new version')
    assert_equal edit_label_path(@dog_en, lang: 'en', format: 'html'), current_path
    assert page.has_content? 'Instance copy has been created and locked.'

    # add translation dog_en => dog_de
    fill_in 'label_relation_skosxl_unidirectional_relations', with: 'dog_de'
    click_link_or_button('Save')

    assert page.has_content? 'Label has been successfully modified.'
    click_link_or_button('Publish')

    # check db relations
    dog_en_with_unidirectional_relalation = Iqvoc::XLLabel.base_class.find_by(origin: 'dog_en')
    assert_equal 1, dog_en_with_unidirectional_relalation.label_relation_skosxl_unidirectional_relations.size
    assert_equal 'dog_de', dog_en_with_unidirectional_relalation.label_relation_skosxl_unidirectional_relations.first.range.origin

    old_dog_de = Iqvoc::XLLabel.base_class.find_by(origin: 'dog_de')
    assert old_dog_de.label_relation_skosxl_unidirectional_relations.empty?

    # remove previously added unidirectional relation
    click_link_or_button('Create new version')
    fill_in 'label_relation_skosxl_unidirectional_relations', with: ''
    click_link_or_button('Save')
    assert page.has_content? 'Label has been successfully modified.'
    click_link_or_button('Publish')

    # check if relations are destroyed
    dog_en_without_relations = Iqvoc::XLLabel.base_class.find_by(origin: 'dog_en')
    assert dog_en_without_relations.label_relation_skosxl_unidirectional_relations.empty?

    dog_de_without_translation = Iqvoc::XLLabel.base_class.find_by(origin: 'dog_de')
    assert dog_de_without_translation.label_relation_skosxl_unidirectional_relations.empty?
  end
end
