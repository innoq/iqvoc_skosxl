module IqvocSkosxlHelper

  def render_label(label)
    if label.new_record?
      '-'
    elsif label.is_a?(Label::SKOSXL::Base)
      link_to(label.to_s, label_path(:id => label))
    else
      label.to_s
    end
  end

  def search_result_label(label, concept)
    str = ActiveSupport::SafeBuffer.new
    str << label
    str << " (#{concept.additional_info})" if concept.additional_info
    str
  end

end
