# encoding: UTF-8

class Label::SKOSXL::Base < Label::Base
  include Versioning
  include FirstLevelObjectValidations
  include Label::SKOSXL::Validations

  class_attribute :rdf_namespace, :rdf_class
  self.rdf_namespace = 'skosxl'
  self.rdf_class = 'Label'

  # ********** Hooks

  after_initialize do |label|
    if label.origin.blank?
      label.origin = Origin.new.to_s
    end
  end

  after_save do |label|
    # Handle save or destruction of inline relations for use with widgets
    (@inline_assigned_relations ||= {}).each do |relation_class_name, new_origins|
      # Remove all existing associated labelings of the given type
      existing_origins = label.send(relation_class_name.to_relation_name).map { |r| r.range.origin }.uniq
      Iqvoc::XLLabel.base_class.by_origin(existing_origins).each do |l|
        if relation_class_name.constantize.bidirectional?
          label.send(relation_class_name.to_relation_name).destroy_with_bidirectional_relation(l)
        else
          relation = label.send(relation_class_name.to_relation_name).find_by(range: l)
          relation.destroy if relation
        end
      end

      # Recreate relations reflecting the widget's parameters
      Iqvoc::XLLabel.base_class.by_origin(new_origins).each do |l|
        if relation_class_name.constantize.bidirectional?
          label.send(relation_class_name.to_relation_name).create_with_bidirectional_relation(l)
        else
          label.send(relation_class_name.to_relation_name).create(range: l)
        end
      end
    end
  end

  # ********** "Static"/unconfigureable relations

  @nested_relations = [] # Will be marked as nested attributes later

  has_many :labelings, class_name: 'Labeling::Base', foreign_key: 'target_id', dependent: :destroy
  include_to_deep_cloning(:labelings)
  has_many :concepts, through: :labelings, source: :owner

  has_many :relations, foreign_key: 'domain_id', class_name: 'Label::Relation::Base', dependent: :destroy
  # Which references are pointing to this label?
  has_many :referenced_by_relations, foreign_key: 'range_id', class_name: 'Label::Relation::Base', dependent: :destroy
  include_to_deep_cloning(:relations, :referenced_by_relations)

  has_many :notes, as: :owner, class_name: 'Note::Base', dependent: :destroy
  has_many :annotations, through: :notes, source: :annotations
  include_to_deep_cloning(notes: :annotations)

  # ************** "Dynamic"/configureable relations

  Iqvoc::XLLabel.note_class_names.each do |note_class_name|
    has_many note_class_name.to_relation_name, as: :owner, class_name: note_class_name, dependent: :destroy
    @nested_relations << note_class_name.to_relation_name
  end

  Iqvoc::XLLabel.relation_class_names.each do |relation_class_name|
    has_many relation_class_name.to_relation_name,
      foreign_key: 'domain_id',
      class_name: relation_class_name,
      extend: Label::Relation::BidirectionalRelationExtension,
      dependent: :destroy

    has_many "#{relation_class_name.to_relation_name}_of".to_sym,
      foreign_key: 'range_id',
      class_name: relation_class_name,
      dependent: :destroy

    # Serialized setters and getters (\r\n or , separated)
    define_method("inline_#{relation_class_name.to_relation_name}".to_sym) do
      (@inline_assigned_relations && @inline_assigned_relations[relation_class_name]) ||
        self.send(relation_class_name.to_relation_name).map { |r| r.range.origin }.uniq
    end

    define_method("inline_#{relation_class_name.to_relation_name}=".to_sym) do |value|
      # write to instance variable and write it on after_save
      (@inline_assigned_relations ||= {})[relation_class_name] = value.
        split(/\r\n|, */).map(&:strip).reject(&:blank?).uniq
    end
  end

  Iqvoc::XLLabel.additional_association_classes.each do |association_class, foreign_key|
    has_many association_class.name.to_relation_name, class_name: association_class.name, foreign_key: foreign_key, dependent: :destroy
    include_to_deep_cloning(association_class.deep_cloning_relations)
    association_class.referenced_by(self)
  end

  # ********** Relation Stuff

  @nested_relations.each do |relation|
    accepts_nested_attributes_for relation, allow_destroy: true, reject_if: Proc.new { |attrs| attrs[:value].blank? }
  end

  # ********** Scopes

  def self.by_origin(origin)
    where(origin: origin)
  end

  def self.with_associations
    includes(labelings: :owner)
  end

  def self.for_dashboard
    unpublished_or_follow_up.includes(:locking_user)
  end

  # ********** Methods

  def self.single_query(params = {})
    query_str = build_query_string(params)

    scope = self.by_query_value(query_str)
                .by_language(params[:languages].to_a)
                .includes(:concepts)
                .references(:concepts)
                .published
                .order("LENGTH(#{Label::Base.table_name}.value)")

    if params[:collection_origin].present?
      collection = Collection::Base.where(origin: params[:collection_origin]).last
      if collection
        scope = scope.includes(concepts: [ collections: { collection_members: :collection } ])
        scope = scope.where("#{Collection::Member::Base.table_name}.collection_id" => collection.id)
      else
        raise "Collection with Origin #{params[:collection_origin]} not found!"
      end
    end

    # apply search entity type
    case params[:for]
    when 'concept'
      scope = scope.includes(:concepts).merge(Iqvoc::Concept.base_class.published)
    when 'collection'
      scope = scope.includes(:concepts).merge(Iqvoc::Collection.base_class.published)
    end


    # change note filtering
    if params[:change_note_date_from].present? || params[:change_note_date_to].present?
      change_note_relation = Iqvoc.change_note_class_name.to_relation_name

      scope = scope.includes(change_note_relation.to_sym => :annotations)
                   .references(change_note_relation)
                   .references('note_annotations')


      # change note type filtering
      scope = case params[:change_note_type]
              when 'created'
                scope.where('note_annotations.predicate = ?', 'created')
              when 'modified'
                scope.where('note_annotations.predicate = ?', 'modified')
              else
                scope.where('note_annotations.predicate = ? OR note_annotations.predicate = ?', 'created', 'modified')
              end

      if params[:change_note_date_from].present?
        begin
          DateTime.parse(params[:change_note_date_from])
          date_from = params[:change_note_date_from]
          scope = scope.where('note_annotations.value >= ?', date_from)
        rescue ArgumentError
          Rails.logger.error "Invalid date was entered for search"
        end
      end

      if params[:change_note_date_to].present?
        begin
          DateTime.parse(params[:change_note_date_to])
          date_to = params[:change_note_date_to]
          scope = scope.where('note_annotations.value <= ?', date_to)
        rescue ArgumentError
          Rails.logger.error "Invalid date was entered for search"
        end
      end
    end

    scope = yield(scope) if block_given?
    scope.map { |result| SearchResult.new(result) }
  end

  def self.search_result_partial_name
    'partials/label/skosxl/search_result'
  end

  def self.new_link_partial_name
    'partials/label/skosxl/new_link_base'
  end

  def self.edit_link_partial_name
    'partials/label/skosxl/edit_link_base'
  end

  def notes_for_class(note_class)
    note_class = note_class.name if note_class < ActiveRecord::Base # Use the class name string
    notes.select{ |note| note.class.name == note_class }
  end

  def relations_for_class(relation_class)
    relation_class = relation_class.name if relation_class < ActiveRecord::Base # Use the class name string
    relations.select{ |rel| rel.class.name == relation_class }
  end

  def build_rdf_subject(&block)
    ns = IqRdf::Namespace.find_namespace_class(self.rdf_namespace.to_sym)
    raise "Namespace '#{rdf_namespace}' is not defined in IqRdf document." unless ns
    IqRdf.build_uri(self.origin, ns.build_uri(self.rdf_class), &block)
  end

  def concepts_for_labeling_class(labeling_class)
    labeling_class = labeling_class.name if labeling_class < ActiveRecord::Base # Use the class name string
    labelings.select{ |l| l.class.name == labeling_class.to_s }.map(&:owner)
  end

  def related_labels_for_relation_class(relation_class, only_published = true)
    relation_class = relation_class.name if relation_class < ActiveRecord::Base # Use the class name string
    relations.select { |rel| rel.class.name == relation_class }
             .map(&:range)
             .select { |l| l.published? || !only_published }
  end

  def notes_for_class(note_class)
    note_class = note_class.name if note_class < ActiveRecord::Base # Use the class name string
    notes.select{ |note| note.class.name == note_class }
  end

  def from_rdf(str)
    raise 'invalid rdf literal' unless str =~ /^"(.+)"(@(.+))$/
    self.value = $1
    self.language = $3
    self
  end

  def from_rdf!(str)
    from_rdf(str)
    save(validate: false)
  end

  def to_param
    origin
  end

  def has_concept_or_label_relations?
    # Check if one of the additional association methods return elements
    Iqvoc::XLLabel.additional_association_classes.each do |association_class, foreign_key|
      return true if send(association_class.name.to_relation_name).count > 0
    end
  end

  # Responsible for displaying a warning message about
  # associated objects which are currently edited y another user.
  def associated_objects_in_editing_mode
    {
      label_relations: Label::Relation::Base.by_domain(id).range_in_edit_mode
    }
  end

  def clone(user)
    clone = dup_with_deep_cloning({except: [:origin, :rev, :published_version_id, :published_at, :expired_at, :to_review, :pos005, :auto_classify], include: [:inflectionals, :notes, :labelings]})

    clone.origin = Origin.new.to_s
    clone.locked_by = user.id
    clone.value += " [#{I18n.t('txt.models.label.copy')}]"

    clone.notes = clone.notes.to_a.delete_if { |n| n.type != Note::SKOS::EditorialNote.to_s }
    clone.build_initial_change_note(user)
    clone.save!
    clone
  end

  # initial created-ChangeNote creation
  def build_initial_change_note(user)
    send(Iqvoc::change_note_class_name.to_relation_name).new do |change_note|
      change_note.value = I18n.t('txt.views.versioning.initial_version')
      change_note.language = I18n.locale.to_s
      change_note.annotations_attributes = [
        { namespace: 'dct', predicate: 'creator', value: user.name },
        { namespace: 'dct', predicate: 'created', value: DateTime.now.to_s }
      ]
    end
  end

  def build_notes
    Iqvoc::XLLabel.note_class_names.each do |note_class_name|
      send(note_class_name.to_relation_name).build if send(note_class_name.to_relation_name).empty?
    end
  end
end
