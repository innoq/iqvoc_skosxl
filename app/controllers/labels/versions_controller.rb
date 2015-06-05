class Labels::VersionsController < ApplicationController
  def merge
    current_label = Iqvoc::XLLabel.base_class.by_origin(params[:origin]).published.last
    new_version = Iqvoc::XLLabel.base_class.by_origin(params[:origin]).unpublished.last!

    authorize! :merge, new_version

    ActiveRecord::Base.transaction do
      if current_label.blank? || current_label.destroy
        new_version.publish
        new_version.unlock
        if new_version.publishable?
          new_version.save
          begin
           # TODO if RdfStore.update(new_version.rdf_uri, label_url(:id => new_version, :format => :ttl))
           #   new_version.update_attribute(:rdf_updated_at, 1.seconds.since)
           # end
          rescue Exception => e
            handle_virtuoso_exception(e.message)
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
      else
        flash[:error] = t('txt.controllers.versioning.merged_delete_error')
        redirect_to label_path(published: 0, id: new_version)
      end
    end
  end

  def branch
    current_label = Iqvoc::XLLabel.base_class.by_origin(params[:origin]).published.last!
    if Iqvoc::XLLabel.base_class.by_origin(params[:origin]).unpublished.last
      raise "There is already an unpublished version for Label '#{params[:origin]}'"
    end

    authorize! :branch, current_label
    new_version = nil
    ActiveRecord::Base.transaction do
      new_version = current_label.branch(current_user)
      new_version.save!
      Iqvoc.change_note_class.create! do |note|
        note.owner = new_version
        note.language = I18n.locale.to_s
        note.annotations_attributes = [
          { namespace: 'dct', predicate: 'creator', value: current_user.name },
          { namespace: 'dct', predicate: 'modified', value: DateTime.now.to_s }
        ]
      end
    end
    flash[:success] = t('txt.controllers.versioning.branched')
    redirect_to edit_label_path(published: 0, id: new_version, check_associations_in_editing_mode: true)
  end

  def lock
    new_version = Iqvoc::XLLabel.base_class.by_origin(params[:origin]).unpublished.last!
    raise "Label with origin '#{params[:origin]}' has already been locked." if new_version.locked?

    authorize! :lock, new_version

    new_version.lock_by_user(current_user.id)
    new_version.save!

    flash[:success] = t('txt.controllers.versioning.locked')
    redirect_to edit_label_path(published: 0, id: new_version)
  end

  def unlock
    new_version = Iqvoc::XLLabel.base_class.by_origin(params[:origin]).unpublished.last!
    raise "Label with origin '#{params[:origin]}' wasn't locked." unless new_version.locked?

    authorize! :unlock, new_version

    new_version.unlock
    new_version.save!

    flash[:success] = t('txt.controllers.versioning.unlocked')
    redirect_to label_path(published: 0, id: new_version)
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
    label.to_review

    authorize! :unlock, label
    label.unlock

    label.save!
    flash[:success] = t('txt.controllers.versioning.to_review_success')
    redirect_to label_path(published: 0, id: label)
  end
end
