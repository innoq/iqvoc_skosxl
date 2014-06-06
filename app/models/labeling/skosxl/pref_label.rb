class Labeling::SKOSXL::PrefLabel < Labeling::SKOSXL::Base
  self.rdf_namespace = 'skosxl'
  self.rdf_predicate = 'prefLabel'

  def self.only_one_allowed?
    true
  end
end
