module IqvocSkosxlHelper

  def iqvoc_skosxl_default_rdf_namespaces
    {
    }
  end

  def render_label(label)
    if label.new_record?
      "-"
    elsif label.is_a?(Label::SKOSXL::Base)
      link_to(label.to_s, label_path(:id => label))
    else
      label.to_s
    end
  end

end
