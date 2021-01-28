class Labeling::SKOSXL::AltLabel < Labeling::SKOSXL::Base
  self.rdf_namespace = 'skosxl'
  self.rdf_predicate = 'altLabel'

  def self.view_section_sort_key(obj)
    60
  end
end
