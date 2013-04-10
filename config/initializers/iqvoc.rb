class DisabledNamespace

  class << self
    attr_accessor :obsolete
  end

  def self.method_missing(meth, *args, &block)
    error
  end

  def self.const_missing(name)
    error
  end

  def self.error
    warn <<-EOS.strip.gsub(/\s+/, " ")
      this namespace has been disabled - the original functionality remains
      available via `obsolete`
    EOS
  end

end

DisabledNamespace.obsolete = Iqvoc::Label
silence_warnings do
  Iqvoc::Label = DisabledNamespace
end

Iqvoc.searchable_class_names = ['Labeling::SKOSXL::Base'] +
    Iqvoc::Concept.labeling_class_names.keys + Iqvoc::Concept.note_class_names
