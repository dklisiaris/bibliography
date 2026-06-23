module ApplicationHelper

  def side_nav_li(text, path, icon=nil, blank=false)
    content_tag(:li, class: ('active' if current_page?(path))) do
      options = { class: 'app-sidebar__link' }
      options[:target] = '_blank' if blank
      link_to path, options do
        parts = []
        parts << content_tag(:i, nil, class: "#{icon} app-sidebar__icon sidebar-nav-icon") if icon
        parts << content_tag(:span, text, class: 'app-sidebar__label sidebar-nav-mini-hide')
        safe_join(parts)
      end
    end
  end

  def sidebar_section(label)
    content_tag(:li, class: 'app-sidebar__section sidebar-separator', role: 'presentation') do
      content_tag(:span, label, class: 'app-sidebar__section-label sidebar-nav-mini-hide')
    end
  end

  def top_nav_li(text, path, icon=nil, klass='')
    li_class = [klass.presence, ('active' if current_page?(path))].compact.join(' ')
    content_tag(:li, class: li_class.presence) do
      link_to path do
        parts = []
        parts << content_tag(:i, nil, class: icon) if icon.present?
        parts << content_tag(:strong, text.upcase) if text.present?
        safe_join(parts)
      end
    end
  end

  def top_nav_dropdown_li(text, path, icon=nil)
    content_tag(:li) do
      link_to path do
        content_tag(:i, nil, { class: "#{icon} fa-fw float-end" }) + text
      end
    end
  end

  # Produces a font awesome icon html code i.e. <i class="fa fa-home"></i>
  # http://fortawesome.github.io/Font-Awesome/cheatsheet/
  #
  # ==== Examples
  #
  #   fa 'home'
  #   fa('apple')
  #
  def fa(icon)
    content_tag(:i, nil, { class: "fa fa-#{icon}" })
  end

  # Replaces toned greek letters with simple ones
  #
  def detone(text)
    text.tr('άέήίΐόύώ','αεηιιουω')
  end

  # Keeps part of a text and ellipsizes it
  #
  # ==== Attributes
  #
  # * +text+ - The text to be cutted
  # * +max_chars+ - The # of characters to keep
  #
  # ==== Examples
  #
  #   subtext ('hello world!', 5)
  #   => 'hello...'
  #
  def subtext(text, max_chars)
    if text.present? and text.length<=max_chars
      text.html_safe
    elsif text.present? and text.length>max_chars
      (text[0...max_chars]+'...').html_safe
    else
      nil
    end
  end

  def latinize(input, opts={})
    opts[:max_expansions]  ||= 1
    opts[:dashes] ||= false
    join_with = opts[:dashes] ? '-' : ' '

    converter = Greeklish.converter(max_expansions: opts[:max_expansions], generate_greek_variants: false)
    name_to_latinize = detone(UnicodeUtils.downcase(input).gsub('ς','σ').gsub(/[,.:'·-]/,''))
    name_to_latinize.split(" ").map do |word|
      converted = converter.convert(word)
      converted.present? ? converted : word
    end.flatten.uniq.join(join_with)
  end

  # Elasticsearch 7+ returns hits total as { "value" => N, "relation" => "eq"|"gte" }.
  def search_results_total_label(search_results)
    total = search_results.response["hits"]["total"]
    return number_with_delimiter(total.to_i) unless total.is_a?(Hash)

    count = number_with_delimiter(total["value"].to_i)
    total["relation"] == "gte" ? t("books.results_count.more_than", count: count) : count
  end

end
