silence_warnings do
  Iqvoc::Label = nil
end

Iqvoc.searchable_class_names = {
    'Labeling::SKOSXL::Base' => 'labels',
    'Labeling::SKOSXL::PrefLabel' => 'pref_labels',
    'Labeling::SKOSXL::AltLabel' => 'alt_labels'
}


module SkosXlExporterExtensions
  extend ActiveSupport::Concern
  include LabelsHelper

  def add_skos_xl_labels(document)
    @logger.info "Exporting xl labels..."

    offset = 0
    while true
      labels = Iqvoc::XLLabel.base_class.published.published.order("id").limit(100).offset(offset)
      limit = labels.size < 100 ? labels.size : 100
      break if labels.size == 0

      labels.each do |label|
        render_label_rdf(document, label)
      end

      @logger.info "Labels #{offset+1}-#{offset+limit} exported."
      offset += labels.size # Size is important!
    end

    @logger.info "Finished exporting xl labels (#{offset} labels exported)."
  end

end


module Iqvoc
  class SkosExporter
    include SkosXlExporterExtensions
  end
end

ActiveSupport.on_load :rdf_export_before_save do
  add_skos_xl_labels(@document)
end

ActiveSupport.on_load :skos_importer do
  Iqvoc::SkosImporter::FIRST_LEVEL_OBJECT_CLASSES << Iqvoc::XLLabel.base_class
  Iqvoc::SkosImporter::SECOND_LEVEL_OBJECT_CLASSES << Label::SKOSXL::Properties::LiteralForm
end
