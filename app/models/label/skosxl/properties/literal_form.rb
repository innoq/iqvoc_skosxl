require 'iqvoc/rdfapi'

class Label::SKOSXL::Properties::LiteralForm
  class_attribute :rdf_namespace, :rdf_predicate
  self.rdf_namespace = 'skosxl'
  self.rdf_predicate = 'literalForm'

  def self.build_from_rdf(rdf_subject, rdf_predicate, rdf_object)
    unless rdf_object =~ Iqvoc::RDFAPI::LITERAL_REGEXP
      raise InvalidStringLiteralError,
        "#{self.name}#build_from_rdf: Object (#{rdf_object}) must be a string literal"
    end

    lang = $3
    value = begin
      JSON.parse(%Q{["#{$1}"]})[0].gsub('\\n', "\n") # Trick to decode \uHHHHH chars
    rescue JSON::ParserError
      $1
    end

    rdf_subject.update_attributes(:value => value, :language => lang)
  end
end
