class Labeling::Skosxl::AltLabel < Labeling::Skosxl::Base
  self.rdf_namespace = 'skosxl'
  self.rdf_predicate = 'altLabel'

  def self.view_section_sort_key(obj)
    60
  end

  def build_search_result_rdf(document, result)
    result.Sdc::link(IqRdf.build_uri(owner.origin))
    # also render prefLabel literal and uri to alt labelings
    result.send(Labeling::Skosxl::PrefLabel.rdf_namespace.camelcase).send(Labeling::Skosxl::PrefLabel.rdf_predicate, IqRdf.build_uri(owner.pref_label.origin))
    result.Skos.send(Labeling::Skos::PrefLabel.rdf_predicate, owner.pref_label.value, lang: owner.pref_label.language)
    build_rdf(document, result)
  end
end
