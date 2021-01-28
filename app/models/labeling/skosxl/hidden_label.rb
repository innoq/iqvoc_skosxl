class Labeling::SKOSXL::HiddenLabel < Labeling::SKOSXL::Base
  self.rdf_namespace = 'skosxl'
  self.rdf_predicate = 'hiddenLabel'

  def self.view_section_sort_key(obj)
    70
  end
end
