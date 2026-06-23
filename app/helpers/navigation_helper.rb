module NavigationHelper
  def content_header(title: nil, content: nil, breadcrumbs: nil)
    render partial: 'navigation/content_header', locals: { title: title, content: content, breadcrumbs: breadcrumbs }
  end

  def nav_btn_link_to(name: 'Page Name', url: '#', tooltip: '', style: 'primary')
    link_to name, url, class: "btn btn-#{style}", role: 'button',
            data: { bs_toggle: 'tooltip', 'original-title' => tooltip }
  end

  def ellipsize(text, max_length = 30)
    return text unless text.length > max_length

    "#{text[0..max_length].strip}..."
  end

  def breadcrumb_label(label)
    return label if label.respond_to?(:html_safe?) && label.html_safe?

    ellipsize(label.to_s)
  end
end
