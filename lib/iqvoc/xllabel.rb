module Iqvoc

  module XLLabel # This are the settings when using SKOSXL

    Iqvoc.first_level_class_configuration_modules << self

    mattr_accessor :base_class_name,
      :note_class_names,
      :relation_class_names,
      :additional_association_class_names,
      :view_sections,
      :has_additional_base_data,
      :searchable_class_names

    self.base_class_name                  = 'Label::SKOSXL::Base'

    self.relation_class_names = ['Label::Relation::SKOSXL::Base']

    self.note_class_names = Iqvoc::Concept.note_class_names

    self.additional_association_class_names = {}

    self.view_sections = ["main", "concepts", "relations", "notes"]

    # Set this to true if you're having a migration which extends the labels table
    # and you want to be able to edit these fields.
    # This is done by:
    #    render :partial => 'partials/label/additional_base_data'
    # You'll have to define this partial
    # FIXME: This wouldn't be necessary if there would be an empty partial in
    # iqvoc and the view loading sequence would be correct.
    self.has_additional_base_data = false

    # Do not use the following method in models. This will propably cause a
    # loading loop (something like "expected file xyz to load ...")
    def self.base_class
      base_class_name.constantize
    end

    def self.relation_classes
      relation_class_names.map(&:constantize)
    end

    def self.note_classes
      note_class_names.map(&:constantize)
    end

    def self.change_note_class
      change_note_class_name.constantize
    end

    def self.additional_association_classes
      additional_association_class_names.keys.each_with_object({}) do |class_name, hash|
        hash[class_name.constantize] = additional_association_class_names[class_name]
      end
    end

  end

end