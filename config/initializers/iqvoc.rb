silence_warnings do
  Iqvoc::Label = nil
end

Iqvoc.searchable_class_names = {
  'Label::Skosxl::Base' => 'xllabels',
  'Labeling::Skosxl::Base' => 'labels',
  'Labeling::Skosxl::PrefLabel' => 'pref_labels',
  'Labeling::Skosxl::AltLabel' => 'alt_labels'
}

module SkosXlExporterExtensions
  extend ActiveSupport::Concern

  def add_skos_xl_labels(document)
    @logger.info 'Exporting xl labels...'

    offset = 0
    loop do
      labels = Iqvoc::Xllabel.base_class.published
                             .order('id')
                             .limit(100)
                             .offset(offset)

      limit = labels.size < 100 ? labels.size : 100
      break if labels.size.zero?

      labels.each do |label|
        render_label_rdf(document, label)
      end

      @logger.info "Labels #{offset + 1}-#{offset + limit} exported."
      offset += labels.size # Size is important!
    end

    @logger.info "Finished exporting xl labels (#{offset} labels exported)."
  end
end

ActiveSupport.on_load :rdf_export_before_save do
  class SkosExporter
    include SkosXlExporterExtensions
    include LabelsHelper
  end

  add_skos_xl_labels(@document)
end

ActiveSupport.on_load :skos_importer do
  SkosImporter.prepend_first_level_object_classes(Iqvoc::Xllabel.base_class)
  SkosImporter.second_level_object_classes +=
    [Label::Skosxl::Properties::LiteralForm] +
    Iqvoc::Xllabel.note_classes +
    Iqvoc::Xllabel.relation_classes +
    Iqvoc::Xllabel.additional_association_classes.keys
end
