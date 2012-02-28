class Label::Relation::Base < ActiveRecord::Base

  class_attribute :rdf_namespace, :rdf_predicate
  self.rdf_namespace = nil
  self.rdf_predicate = nil

  self.table_name ='label_relations'

  belongs_to :domain, :class_name => "Label::Base"
  belongs_to :range,  :class_name => "Label::Base"

  def self.by_domain(domain)
    where(:domain_id => domain)
  end

  def self.by_range(range)
    where(:range_id => range)
  end

  def self.by_range_origin(origin)
    includes(:range).merge(Label::Base.by_origin(origin))
  end

  def self.range_editor_selectable
    # includes(:range) & Iqvoc::XLLabel.base_class.editor_selectable
    # Doesn't work correctly (kills label_relations.type condition :-( )
    includes(:range).
    where("labels.published_at IS NOT NULL OR (labels.published_at IS NULL AND labels.published_version_id IS NULL) ")
  end

  def self.range_in_edit_mode
    joins(:range).merge(Iqvoc::XLLabel.base_class.in_edit_mode)
  end

  def self.view_section(obj)
    "relations"
  end

  def self.view_section_sort_key(obj)
    100
  end

  def self.partial_name(obj)
    "partials/label/relation/base"
  end

  def self.edit_partial_name(obj)
    "partials/label/relation/edit_base"
  end

  def self.only_one_allowed?
    false
  end

end
