require 'labels_helper'

silence_warnings do
  Iqvoc::Label = nil
end

Iqvoc.searchable_class_names = {
  'Label::SKOSXL::Base' => 'xllabels',
  'Labeling::SKOSXL::Base' => 'labels',
  'Labeling::SKOSXL::PrefLabel' => 'pref_labels',
  'Labeling::SKOSXL::AltLabel' => 'alt_labels'
}

module SkosXlExporterExtensions
  extend ActiveSupport::Concern
  include LabelsHelper

  def add_skos_xl_labels(document)
    @logger.info 'Exporting xl labels...'

    offset = 0
    loop do
      labels = Iqvoc::XLLabel.base_class.published
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
  end

  add_skos_xl_labels(@document)
end

ActiveSupport.on_load :skos_importer do
  SkosImporter.prepend_first_level_object_classes(Iqvoc::XLLabel.base_class)
  SkosImporter.second_level_object_classes +=
    [Label::SKOSXL::Properties::LiteralForm] +
    Iqvoc::XLLabel.note_classes +
    Iqvoc::XLLabel.relation_classes +
    Iqvoc::XLLabel.additional_association_classes.keys
end
