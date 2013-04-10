class DisabledNamespace

  attr_reader :obsolete

  def initialize(obsolete_namespace)
    @obsolete = obsolete_namespace
  end

  def method_missing(meth, *args, &block)
    error
  end

  def const_missing(name)
    error
  end

  def error
    raise RuntimeError, <<-EOS.strip.gsub(/\s+/, " ")
      this namespace has been disabled - the original functionality remains
      available via `obsolete`
    EOS
  end

end

silence_warnings do
  Iqvoc::Label = DisabledNamespace.new(Iqvoc::Label)
end

Iqvoc.searchable_class_names = ['Labeling::SKOSXL::Base'] +
    Iqvoc::Concept.labeling_class_names.keys + Iqvoc::Concept.note_class_names
