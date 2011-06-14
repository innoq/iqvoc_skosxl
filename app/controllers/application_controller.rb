require_dependency Iqvoc::Engine.find_root_with_flag("app").join("app/controllers/application_controller").to_s

class ApplicationController

  def label_widget_data(label)
    {
      :id => label.origin,
      :name => label.value,
      :lang => label.language
    }
  end

end
