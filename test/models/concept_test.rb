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
end
