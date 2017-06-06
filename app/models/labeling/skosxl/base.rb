class Labeling::SKOSXL::Base < Labeling::Base
  class_attribute :rdf_namespace, :rdf_predicate
  self.rdf_namespace = nil
  self.rdf_predicate = nil

  def self.target_in_edit_mode
    includes(:target).references(:labels).merge(Iqvoc::XLLabel.base_class.in_edit_mode)
  end

  def self.by_label_origin(origin)
    includes(:target).references(:labels).merge(self.label_class.by_origin(origin))
  end

  def self.by_label_language(language)
    includes(:target).references(:labels).merge(self.label_class.by_language(language))
  end

  def self.label_editor_selectable
    includes(:target).references(:labels).merge(self.label_class.editor_selectable)
  end

  def self.create_for(o, t)
    find_or_create_by(owner_id: o.id, target_id: t.id)
  end

  # FIXME: Hmm... Why should I sort labelings (not necessarily pref_labelings) by pref_label???
  def <=>(other)
    owner.pref_label <=> other.owner.pref_label
  end

  def self.label_class
    Iqvoc::XLLabel.base_class
  end

  def self.single_query(params = {})
    query_str = build_query_string(params)

    scope = includes(:target).order("LOWER(#{Label::Base.table_name}.value)").references(:labels, :concepts)
    if params[:query].present?
      labels = Label::Base.by_query_value(query_str).by_language(params[:languages].to_a).published
      scope = scope.merge(labels)
    else
      scope = scope.merge(Label::Base.by_language(params[:languages].to_a).published)
    end

    if params[:collection_origin].present?
      collection = Collection::Base.where(origin: params[:collection_origin]).last
      if collection
        scope = scope.includes(owner: { collection_members: :collection })
        scope = scope.where("#{Collection::Member::Base.table_name}.collection_id" => collection.id)
      else
        raise "Collection with Origin #{params[:collection_origin]} not found!"
      end
    end

    # apply search entity type
    case params[:for]
    when 'concept'
      scope = scope.includes(:owner).merge(Iqvoc::Concept.base_class.published)
    when 'collection'
      scope = scope.includes(:owner).merge(Iqvoc::Collection.base_class.published)
    end

    # change note filtering
    if params[:change_note_date_from].present? || params[:change_note_date_to].present?
      change_note_relation = Iqvoc.change_note_class_name.to_relation_name
      concepts = Concept::Base.base_class.published
                              .includes(change_note_relation.to_sym => :annotations)
                              .references(change_note_relation)
                              .references('note_annotations')

      # change note type filtering
      concepts = case params[:change_note_type]
                 when 'created'
                   concepts.where('note_annotations.predicate = ?', 'created')
                 when 'modified'
                   concepts.where('note_annotations.predicate = ?', 'modified')
                 else
                   concepts
                 end

      if params[:change_note_date_from].present?
        if DateTime.parse(params[:change_note_date_from])
          date_from = params[:change_note_date_from]
          concepts = concepts.where('note_annotations.value >= ?', date_from)
        else
          #TODO: exception
        end
      end

      if params[:change_note_date_to].present?
        if DateTime.parse(params[:change_note_date_to])
          date_to = params[:change_note_date_to]
          concepts = concepts.where('note_annotations.value <= ?', date_to)
        else
          #TODO: exception
        end
      end

      scope = scope.includes(:owner).merge(concepts)
    end

    scope = yield(scope) if block_given?
    scope.map { |result| SearchResult.new(result) }
  end

  def self.search_result_partial_name
    'partials/labeling/skosxl/search_result'
  end

  def self.partial_name(obj)
    'partials/labeling/skosxl/base'
  end

  def self.edit_partial_name(obj)
    'partials/labeling/skosxl/edit_base'
  end

  def self.only_one_allowed?
    false
  end

  def self.build_from_rdf(rdf_subject, rdf_predicate, rdf_object)
    unless rdf_subject.is_a?(Concept::Base)
      raise "#{self.name}#build_from_rdf: Subject (#{rdf_subject}) must be a Concept."
    end

    predicate_class = RDFAPI::PREDICATE_DICTIONARY[rdf_predicate] || self
    predicate_class.create do |klass|
      klass.owner = rdf_subject
      klass.target = rdf_object
    end
  end

  def build_rdf(document, subject)
    subject.send(self.rdf_namespace.camelcase).send(self.rdf_predicate, IqRdf.build_uri(target.origin))
    subject.Skos.send(self.rdf_predicate, target.value.to_s, lang: target.language)
  end

  def build_search_result_rdf(document, result)
    result.Sdc::link(IqRdf.build_uri(owner.origin))
    build_rdf(document, result)
  end
end
