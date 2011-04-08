class Label::Relation::SKOSXL::Base < Label::Relation::Base

  self.rdf_namespace = 'skosxl'

  def build_rdf(document, subject)
    pred = self.class == Label::Relation::SKOSXL::Base ? :labelRelation : self.rdf_predicate
    raise "Match::SKOS::Base#build_rdf: Class #{self.name} needs to define self.rdf_namespace and self.rdf_predicate." unless pred

    subject.send(self.rdf_namespace.camelcase).send(pred, IqRdf.build_uri(range.origin))
  end

end