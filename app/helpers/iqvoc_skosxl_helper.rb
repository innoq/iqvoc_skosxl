module IqvocSkosxlHelper
  def render_label(label)
    if label.new_record?
      '-'
    elsif label.is_a?(Label::Skosxl::Base)
      link_to(label.to_s, label_path(id: label))
    else
      label.to_s
    end
  end

  def delete_button_text(label)
    label.never_published? ? t("txt.views.versioning.delete") : t("txt.views.versioning.delete_copy")
  end

  def search_result_label(label, concept)
    str = ActiveSupport::SafeBuffer.new
    str << label
    str << " (#{concept.additional_info})" if concept.additional_info
    str
  end
end
