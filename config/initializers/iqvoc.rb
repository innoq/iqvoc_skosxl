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

    total = 0
    Iqvoc::Xllabel.base_class.published.find_in_batches(batch_size: @batch_size) do |labels|
      # render_label_rdf touches every association below, so preload them per
      # batch rather than letting each label load them one by one. This has to
      # be the Preloader: Model.preload builds a relation and would leave the
      # records passed to it untouched.
      ActiveRecord::Associations::Preloader.new(records: labels,
          associations: [{ relations: :range }, { notes: :annotations }] +
              Iqvoc::Xllabel.additional_association_class_names.keys.map(&:to_relation_name)).call

      labels.each { |label| render_label_rdf(document, label) }

      @logger.info "Labels #{total + 1}-#{total + labels.size} exported."
      total += labels.size
    end

    @logger.info "Finished exporting xl labels (#{total} labels exported)."
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
