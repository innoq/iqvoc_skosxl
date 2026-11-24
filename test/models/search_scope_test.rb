require File.join(File.expand_path(File.dirname(__FILE__)), '../test_helper')

# `single_query` (array of SearchResult, used by other gems) and `search_scope`
# (relation, used for SQL pagination) have to stay consistent.
class SearchScopeTest < ActiveSupport::TestCase
  setup do
    label = Iqvoc::Xllabel.base_class.create!(value: 'Water', language: 'en', origin: 'search_scope_water', published_at: Time.now)
    concept = Iqvoc::Concept.base_class.create!(origin: 'search_scope_concept', published_at: Time.now)
    Labeling::Skosxl::PrefLabel.create!(owner: concept, target: label)
  end

  def params(attrs = {})
    SearchQuery.new({ query: '' }.merge(attrs)).to_params
  end

  [Labeling::Skosxl::Base, Labeling::Skosxl::PrefLabel, Label::Skosxl::Base].each do |klass|
    test "#{klass} search_scope is a relation" do
      assert_kind_of ActiveRecord::Relation, klass.search_scope(params)
    end

    test "#{klass} single_query wraps the results of search_scope" do
      results = klass.single_query(params)

      assert_equal 1, results.size
      assert results.all?(SearchResult)
      assert_equal klass.search_scope(params).map(&:id), results.map { |r| r.result_object.id }
    end

    test "#{klass} readable_by returns a relation" do
      assert_kind_of ActiveRecord::Relation, klass.search_scope(params).readable_by(Ability.new(nil))
    end
  end

  test 'a block extends the scope of search_scope and single_query' do
    assert_empty Labeling::Skosxl::PrefLabel.search_scope(params(query: 'Water')) { |s| s.where('1 = 0') }
    assert_empty Labeling::Skosxl::PrefLabel.single_query(params(query: 'Water')) { |s| s.where('1 = 0') }
    assert_equal 1, Labeling::Skosxl::PrefLabel.single_query(params(query: 'Water')).size
  end

  test 'search_scope paginates in SQL' do
    scope = Labeling::Skosxl::PrefLabel.search_scope(params).page(1).per(1)

    assert_equal 1, scope.to_a.size
    assert_equal 1, scope.total_count
  end
end
