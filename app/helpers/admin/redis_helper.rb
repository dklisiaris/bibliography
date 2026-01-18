# frozen_string_literal: true

module Admin::RedisHelper
  def type_label_class(type)
    case type
    when 'string'
      'primary'
    when 'hash'
      'info'
    when 'list'
      'success'
    when 'set'
      'warning'
    when 'zset'
      'danger'
    else
      'default'
    end
  end

  def paginate_keys(page, total, per_page)
    total_pages = (total.to_f / per_page).ceil
    return '' if total_pages <= 1

    html = '<nav><ul class="pagination">'
    
    # Previous link
    if page > 1
      html += content_tag(:li) do
        link_to '&laquo;'.html_safe, admin_redis_path(page: page - 1, pattern: params[:pattern], namespace: params[:namespace])
      end
    else
      html += content_tag(:li, class: 'disabled') do
        content_tag(:span, '&laquo;'.html_safe)
      end
    end

    # Page numbers
    start_page = [page - 2, 1].max
    end_page = [page + 2, total_pages].min

    (start_page..end_page).each do |p|
      if p == page
        html += content_tag(:li, class: 'active') do
          content_tag(:span, p)
        end
      else
        html += content_tag(:li) do
          link_to p, admin_redis_path(page: p, pattern: params[:pattern], namespace: params[:namespace])
        end
      end
    end

    # Next link
    if page < total_pages
      html += content_tag(:li) do
        link_to '&raquo;'.html_safe, admin_redis_path(page: page + 1, pattern: params[:pattern], namespace: params[:namespace])
      end
    else
      html += content_tag(:li, class: 'disabled') do
        content_tag(:span, '&raquo;'.html_safe)
      end
    end

    html += '</ul></nav>'
    html.html_safe
  end
end
