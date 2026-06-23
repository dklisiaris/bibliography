module DeviseHelper
  def devise_error_messages!
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join

    content_tag(:div, class: "alert alert-danger", role: "alert") do
      content_tag(:ul, messages.html_safe, class: "mb-0")
    end
  end

  def devise_error_messages?
    resource.errors.present?
  end
end
