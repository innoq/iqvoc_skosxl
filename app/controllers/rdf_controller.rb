require_dependency Iqvoc.root.join('app/controllers/rdf_controller').to_s

# TODO: move out of /controllers
module RdfControllerLabelExtension
  def show
    scope = params[:published] == '0' ? Iqvoc::XLLabel.base_class.unpublished : Iqvoc::XLLabel.base_class.published
    if @label = scope.by_origin(params[:id]).with_associations.last
      respond_to do |format|
        format.html {
          redirect_to label_url(id: @label.origin, published: params[:published])
        }
        format.any {
          authorize! :read, @label
          render 'show_label'
        }
      end
    else
      super
    end
  end
end

RdfController.prepend(RdfControllerLabelExtension)