class Labeling::Skosxl::PrefLabel < Labeling::Skosxl::Base
  self.rdf_namespace = 'skosxl'
  self.rdf_predicate = 'prefLabel'

  def self.only_one_allowed?
    true
  end

  def self.view_section_sort_key(obj)
    50
  end
end
