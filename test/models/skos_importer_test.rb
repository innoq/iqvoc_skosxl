# encoding: UTF-8

require File.expand_path('../../test_helper', __FILE__)
require 'iqvoc/skos_importer'

class SkosImporterTest < ActiveSupport::TestCase
  TEST_DATA = File.open(File.expand_path("../../fixtures/hobbies.nt", __FILE__))

  test "imports xl labels with relations" do
    assert_equal 0, Concept::SKOS::Base.count
    assert_equal 0, Label::SKOSXL::Base.count

    Iqvoc::SkosImporter.new(TEST_DATA, "http://hobbies.com#").run

    assert_equal 1, Labeling::SKOSXL::PrefLabel.count
    assert_equal 1, Labeling::SKOSXL::AltLabel.count
    assert_equal 2, Label::SKOSXL::Base.count
    assert_equal 1, Concept::SKOS::Base.count

    concept = Concept::SKOS::Base.published.first!
    pref_label = Labeling::SKOSXL::PrefLabel.first!
    alt_label = Labeling::SKOSXL::AltLabel.first!

    assert concept.pref_label.published?
    assert_equal "computer_programming-xl-preflabel-en", concept.pref_label.origin
    assert_equal "Computer programming (used as xl:prefLabel)", concept.pref_label.value
    assert_equal "en", concept.pref_label.language
    assert_equal 1, concept.pref_label.notes_for_class(Note::SKOS::Definition).count
    assert_equal "en", concept.pref_label.notes_for_class(Note::SKOS::Definition).first.language
    assert_equal "Bla bla bla", concept.pref_label.notes_for_class(Note::SKOS::Definition).first.value

    assert_equal concept, alt_label.owner
    assert alt_label.target.published?
    assert_equal "computer_programming-xl-altlabel-en", alt_label.target.origin
    assert_equal "Computer programming (used as xl:altLabel)", alt_label.target.value
    assert_equal "en", alt_label.target.language
    assert_equal 1, alt_label.target.notes_for_class(Note::SKOS::Definition).count
    assert_equal "en", alt_label.target.notes_for_class(Note::SKOS::Definition).first.language
    assert_equal "Yadda yadda", alt_label.target.notes_for_class(Note::SKOS::Definition).first.value
  end
end
