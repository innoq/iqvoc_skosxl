# encoding: UTF-8

require File.expand_path('../../test_helper', __FILE__)

class SkosImporterTest < ActiveSupport::TestCase
  TEST_DATA = File.open(File.expand_path('../../fixtures/hobbies.nt', __FILE__))

  setup do
    Iqvoc.rdf_namespaces[:test] = 'http://foo.bar/xl#'

    class TestRelation < Label::Relation::Skosxl::Base
      self.rdf_namespace = 'test'
      self.rdf_predicate = 'test-relation'
    end

    @importer = SkosImporter.new(TEST_DATA, 'http://hobbies.com/')
    @importer.second_level_object_classes << TestRelation
  end

  test 'imports xl labels with relations' do
    assert_equal 0, Concept::Skos::Base.count
    assert_equal 0, Label::Skosxl::Base.count

    @importer.run

    assert_equal 1, Labeling::Skosxl::PrefLabel.count
    assert_equal 1, Labeling::Skosxl::AltLabel.count
    assert_equal 2, Label::Skosxl::Base.count
    assert_equal 1, Concept::Skos::Base.count

    concept = Concept::Skos::Base.published.first!
    pref_label = Labeling::Skosxl::PrefLabel.first!
    alt_label = Labeling::Skosxl::AltLabel.first!

    assert concept.pref_label.published?
    assert_equal 'computer_programming-xl-preflabel-en', concept.pref_label.origin
    assert_equal 'Computer programming (used as xl:prefLabel)', concept.pref_label.value
    assert_equal 'en', concept.pref_label.language
    assert_equal 1, concept.pref_label.notes_for_class(Note::Skos::Definition).count
    assert_equal 'en', concept.pref_label.notes_for_class(Note::Skos::Definition).first.language
    assert_equal 'Bla bla bla', concept.pref_label.notes_for_class(Note::Skos::Definition).first.value

    assert_equal concept, alt_label.owner
    assert alt_label.target.published?
    assert_equal 'computer_programming-xl-altlabel-en', alt_label.target.origin
    assert_equal 'Computer programming (used as xl:altLabel)', alt_label.target.value
    assert_equal 'en', alt_label.target.language
    assert_equal 1, alt_label.target.notes_for_class(Note::Skos::Definition).count
    assert_equal 'en', alt_label.target.notes_for_class(Note::Skos::Definition).first.language
    assert_equal 'Yadda yadda', alt_label.target.notes_for_class(Note::Skos::Definition).first.value
    assert_equal 1, alt_label.target.relations_for_class(TestRelation).count
    assert_equal pref_label.target, alt_label.target.relations_for_class(TestRelation).first.range
  end
end
