module ApplicationHelper

  def side_nav_li(text, path, icon=nil, blank=false)
    content_tag(:li) do
      options = current_page?(path) ? { class: "active" } : {}
      options[:target] = '_blank' if blank
      if icon
        link_to path, options do
          "<i class='#{icon} sidebar-nav-icon'></i><span class='sidebar-nav-mini-hide'>#{text}</span>".html_safe
        end
      else
        link_to(text, path, options)
      end
    end
  end

  def top_nav_li(text, path, icon=nil, klass='')
    content_tag(:li) do
      options = current_page?(path) ? { class: "active #{klass}" } : { class: klass }
      link_to path, options do
        "<i class='#{icon}'></i><strong>#{text.upcase}</strong>".html_safe
      end
    end
  end

  def top_nav_dropdown_li(text, path, icon=nil)
    content_tag(:li) do
      link_to path do
        content_tag(:i, nil, { class: "#{icon} fa-fw pull-right" }) + text
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

end
