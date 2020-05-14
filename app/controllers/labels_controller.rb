class LabelsController < ApplicationController
  before_action proc { |ctrl| (ctrl.action_has_layout = false) if ctrl.request.xhr? }

  def index
    authorize! :read, Iqvoc::XLLabel.base_class

    search_string = search_string(params[:query], params[:mode])
    scope = Iqvoc::XLLabel.base_class
                          .editor_selectable
                          .by_query_value(search_string)

    if params[:language] # NB: this is not the same as :lang, which is supplied via route
      scope = scope.by_language(params[:language])
    end
    @labels = scope.order(Arel.sql("LENGTH(#{Iqvoc::XLLabel.base_class.table_name}.value)")).all

    respond_to do |format|
      format.html do
        redirect_to action: 'index', format: 'txt'
      end
      format.text do
        render content_type: 'text/plain',
          text: @labels.map { |label| "#{label.origin}: #{label.value}" }.join("\n")
      end
      format.json do
        response = []
        # group labels to avoid duplicates
        # FIXME: filter in SQL directly
        @labels.group_by { |l| l.origin }.each { |origin, labels|
          response << label_widget_data(labels.first)
        }

        render json: response
      end
    end
  end

  def show
    scope = Iqvoc::XLLabel.base_class.by_origin(params[:id]).with_associations

    @published = params[:published] == '1' || !params[:published]
    if @published
      scope = scope.published
      @new_label_version = Iqvoc::XLLabel.base_class.by_origin(params[:id]).unpublished.last
    else
      scope = scope.unpublished
    end

    @label = scope.last!

    authorize! :read, @label

    respond_to do |format|
      format.html do
        @published ? render('show_published') : render('show_unpublished')
      end
      format.ttl
    end
  end

  def new
    authorize! :create, Iqvoc::XLLabel.base_class
    @label = Iqvoc::XLLabel.base_class.new
    @label.build_initial_change_note(current_user)
    @label.build_notes
  end

  def create
    authorize! :create, Iqvoc::XLLabel.base_class

    @label = Iqvoc::XLLabel.base_class.new(label_params)
    @label.lock_by_user(current_user.id)

    if @label.valid?
      if @label.save
        flash[:success] = I18n.t('txt.controllers.versioned_label.success')
        redirect_to label_path(published: 0, id: @label.origin)
      else
        flash.now[:error] = I18n.t('txt.controllers.versioned_label.error')
        render :new
      end
    else
      flash.now[:error] = I18n.t('txt.controllers.versioned_label.error')
      render :new
    end
  end

  def edit
    @label = Iqvoc::XLLabel.base_class.by_origin(params[:id]).unpublished.last!
    authorize! :update, @label

    if params[:check_associations_in_editing_mode]
      @association_objects_in_editing_mode = @label.associated_objects_in_editing_mode
    end

    # @pref_labelings = PrefLabeling.by_label(@label).all(:include => {:owner => :pref_labels}).sort
    # @alt_labelings = AltLabeling.by_label(@label).all(:include => {:owner => :pref_labels}).sort

    if params[:full_consistency_check]
      @label.publishable?
    end

    @label.build_notes
  end

  def update
    @label = Iqvoc::XLLabel.base_class.by_origin(params[:id]).unpublished.last!
    authorize! :update, @label

    # set to_review to false if someone edits a label
    label_params["to_review"] = "false"

    respond_to do |format|
      format.html do
        if @label.update_attributes(label_params)
          flash[:success] = I18n.t('txt.controllers.versioned_label.update_success')
          redirect_to label_path(published: 0, id: @label)
        else
          flash.now[:error] = I18n.t('txt.controllers.versioned_label.update_error')
          render action: :edit
        end
      end
    end
  end

  def destroy
    @new_label = Iqvoc::XLLabel.base_class.by_origin(params[:id]).unpublished.last!
    authorize! :destroy, @new_label

    if @new_label.destroy
      published_label = Iqvoc::XLLabel.base_class.published.by_origin(@new_label.origin).first
      flash[:success] = I18n.t('txt.controllers.label_versions.delete')
      redirect_to published_label.present? ? label_path(id: published_label.origin) : dashboard_path
    else
      flash[:error] = I18n.t('txt.controllers.label_versions.delete_error')
      redirect_to label_path(published: 0, id: @new_label)
    end
  end

  def duplicate
    authorize! :create, Iqvoc::XLLabel.base_class
    label = Iqvoc::XLLabel.base_class.by_origin(params[:origin]).published.first
    if Iqvoc::XLLabel.base_class.by_origin(params[:origin]).unpublished.last
      flash[:error] = t('txt.controllers.label.duplicate_error')
      redirect_to label_path(published: 1, id: label)
    end

    @new_label = label.duplicate(current_user)
    @new_label.build_notes
  end

  def new_from_concept
    authorize! :create, Iqvoc::XLLabel.base_class
    @label = Iqvoc::XLLabel.base_class.new

    respond_to do |format|
      format.html do
        render layout: false
      end
    end
  end

  def create_from_concept
    authorize! :create, Iqvoc::XLLabel.base_class

    @label = Iqvoc::XLLabel.base_class.new(label_params)
    @label.build_initial_change_note(current_user)
    @label.lock_by_user(current_user.id)

    if @label.save
      #TODO: idea for solving this
      #flash[:success] = I18n.t('txt.controllers.versioned_label.success')
      head :created
    else
      #TODO: idea for solving this
      #flash.now[:error] = I18n.t('txt.controllers.versioned_label.error')
      head :bad_request
    end
  end

  private

  def label_params
    params.require(:label).permit!
  end

  def search_string(query, mode = 'contains')
    if mode == 'exact_match'
      "#{query}"
    elsif mode == 'begins'
      "#{query}%"
    else
      "%#{query}%"
    end
  end
end
