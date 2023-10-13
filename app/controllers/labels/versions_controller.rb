class Labels::VersionsController < ApplicationController
  def merge
    current_label = Iqvoc::XLLabel.base_class.by_origin(params[:origin]).published.last
    new_version = Iqvoc::XLLabel.base_class.by_origin(params[:origin]).unpublished.last!

    authorize! :merge, new_version

    ActiveRecord::Base.transaction do
      new_version.publish

      if new_version.publishable?
        new_version.save
        begin
         # TODO if RdfStore.update(new_version.rdf_uri, label_url(:id => new_version, :format => :ttl))
         #   new_version.update_attribute(:rdf_updated_at, 1.seconds.since)
         # end
        rescue Exception => e
          handle_virtuoso_exception(e.message)
        end

        if current_label && !current_label.destroy
          flash[:error] = t('txt.controllers.versioning.merged_delete_error')
          redirect_to label_path(published: 0, id: new_version)
        end

        if new_version.has_concept_or_label_relations?
          flash[:success] = t('txt.controllers.versioning.published')
          redirect_to label_path(id: new_version)
        else
          flash[:error] = t('txt.controllers.versioning.published_with_warning')
          redirect_to label_path(id: new_version)
        end

      else
        flash[:error] = t('txt.controllers.versioning.merged_publishing_error')
        redirect_to label_path(published: 0, id: new_version)
      end
    end
  end

  def branch
    current_label = Iqvoc::XLLabel.base_class.by_origin(params[:origin]).published.last!

    if draft_label = Iqvoc::XLLabel.base_class.by_origin(params[:origin]).unpublished.last
      flash[:info] = t('txt.controllers.versioning.branch_error')
      redirect_to label_path(published: 0, id: draft_label)
    else
      authorize! :branch, current_label
      new_version = nil
      ActiveRecord::Base.transaction do
        new_version = current_label.branch
        new_version.save!
        Iqvoc.change_note_class.create! do |note|
          note.owner = new_version
          note.language = I18n.locale.to_s
          note.position = (current_label.send(Iqvoc.change_note_class_name.to_relation_name).maximum(:position) || 0).succ
          note.annotations_attributes = [
            { namespace: 'dct', predicate: 'creator', value: current_user.name },
            { namespace: 'dct', predicate: 'modified', value: DateTime.now.to_s }
          ]
        end
      end
      flash[:success] = t('txt.controllers.versioning.branched')
      redirect_to edit_label_path(published: 0, id: new_version, check_associations_in_editing_mode: true)
    end
  end

  def consistency_check
    label = Iqvoc::XLLabel.base_class.by_origin(params[:origin]).unpublished.last!

    authorize! :check_consistency, label

    if label.publishable?
      flash[:success] = t('txt.controllers.versioning.consistency_check_success')
      redirect_to label_path(published: 0, id: label)
    else
      flash[:error] = t('txt.controllers.versioning.consistency_check_error')
      redirect_to edit_label_path(published: 0, id: label, full_consistency_check: 1)
    end
  end

  def to_review
    label = Iqvoc::XLLabel.base_class.by_origin(params[:origin]).unpublished.last!

    authorize! :send_to_review, label

    if label.publishable?
      label.to_review

      label.save!
      flash[:success] = t('txt.controllers.versioning.to_review_success')
      redirect_to label_path(published: 0, id: label)
    else
      flash[:error] = t('txt.controllers.versioning.consistency_check_error')
      redirect_to edit_label_path(published: 0, id: label, full_consistency_check: 1)
    end
  end
end
