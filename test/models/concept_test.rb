# encoding: UTF-8

require File.join(File.expand_path(File.dirname(__FILE__)), '../test_helper')

class ConceptTest < ActiveSupport::TestCase
  setup do
  end

  test 'exclusive pref label' do
    monkey = RDFAPI.devour 'Monkey', 'a', 'skos:Concept'
    monkey_label = Iqvoc::XLLabel.base_class.create(
      language: 'en', value: 'Monkey', published_at: 3.days.ago)

    monkey.pref_labels << monkey_label
    assert monkey.save
    assert monkey.publishable?

    monkey.alt_labels << monkey_label
    assert monkey.save
    refute monkey.publishable?, 'There should be no duplicates between prefLabel/altLabel'
  end

  test 'unique alt labels' do
    tiger = RDFAPI.devour 'Tiger', 'a', 'skos:Concept'
    tiger_label = Iqvoc::XLLabel.base_class.create(
      language: 'en', value: 'Tiger', published_at: 3.days.ago)
    tiger_alt_label = Iqvoc::XLLabel.base_class.create(
      language: 'en', value: 'Big Cat', published_at: 3.days.ago)

    tiger.pref_labels << tiger_label
    tiger.alt_labels << tiger_alt_label
    assert tiger.save
    assert tiger.publishable?

    tiger.alt_labels << tiger_alt_label
    assert tiger.save
    refute tiger.publishable?, 'There should be no identical alt labels'
  end

  test 'concepts alt label language change' do
    dog = RDFAPI.devour 'Dog', 'a', 'skos:Concept'
    dog.pref_labels << Iqvoc::XLLabel.base_class.create(
      language: 'en', value: 'Dog', published_at: 3.days.ago)
    dog.alt_labels << Iqvoc::XLLabel.base_class.create(
      language: 'en', value: 'Hound', published_at: 3.days.ago)

    assert dog.save
    assert dog.publish

    alt_label = dog.alt_labels.first
    assert_equal 'Hound', alt_label.value
    assert_equal 'en', alt_label.language

    # should be publishable with a german alt label
    alt_label.value = 'Jagdhund'
    alt_label.language = 'de'
    assert alt_label.save
    assert alt_label.publishable?
  end

  test 'additional unpublished label revision do not prevent published' do
    dog = RDFAPI.devour 'Dog', 'a', 'skos:Concept'
    dog.pref_labels << Iqvoc::XLLabel.base_class.create(
      language: 'en', value: 'Dog', published_at: 3.days.ago)
    dog.alt_labels << Iqvoc::XLLabel.base_class.create(
      language: 'en', value: 'Hound', published_at: nil)

    assert dog.save
    assert dog.publishable?
    assert dog.publish
  end

  test 'concepts pref label language change' do
    dog = RDFAPI.devour 'Dog', 'a', 'skos:Concept'
    refute dog.publishable?
    dog.pref_labels << Iqvoc::XLLabel.base_class.create(
      language: 'en', value: 'Dog', published_at: 3.days.ago)

    assert dog.save!
    assert dog.publishable?
    assert dog.publish!
    pref_label = dog.pref_label
    assert_equal 'Dog', pref_label.value
    assert_equal 'en', pref_label.language

    # should not be publishable with an german prefLabel
    pref_label.value = 'Hund'
    pref_label.language = 'de'
    assert pref_label.save!
    refute pref_label.publishable?, 'Label should not be publishable (no english pref Label)'

    # no problem with a english prefLabel
    pref_label.value = 'Dog'
    pref_label.language = 'en'
    assert pref_label.save!
    assert pref_label.publishable?, 'Label should not be publishable (no english pref Label)'
  end
end
