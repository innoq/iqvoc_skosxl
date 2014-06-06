class Label::Relation::SKOSXL::Base < Label::Relation::Base
  self.rdf_namespace = 'skosxl'

  def self.build_from_rdf(subject, predicate, object)
    create(domain: subject, range: object)
  end

  def build_rdf(document, subject)
    pred = self.class == Label::Relation::SKOSXL::Base ? :labelRelation : self.rdf_predicate
    raise "Match::SKOS::Base#build_rdf: Class #{self.class.name} needs to define self.rdf_namespace and self.rdf_predicate." unless pred

    subject.send(self.rdf_namespace.camelcase).send(pred, IqRdf.build_uri(range.origin))
  end
end
