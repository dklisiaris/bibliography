# frozen_string_literal: true

module Admin::RedisHelper
  def type_badge_class(type)
    case type
    when 'string'
      'text-bg-primary'
    when 'hash'
      'text-bg-info'
    when 'list'
      'text-bg-success'
    when 'set'
      'text-bg-warning'
    when 'zset'
      'text-bg-danger'
    else
      'text-bg-secondary'
    end
  end

  def paginate_keys(page, total, per_page)
    total_pages = (total.to_f / per_page).ceil
    return '' if total_pages <= 1

    html = '<ul class="pagination">'

    if page > 1
      html += content_tag(:li, class: 'page-item') do
        link_to '&laquo;'.html_safe, admin_redis_path(page: page - 1, pattern: params[:pattern], namespace: params[:namespace]), class: 'page-link', aria: {label: 'Previous'}
      end
    else
      html += content_tag(:li, class: 'page-item disabled') do
        content_tag(:span, '&laquo;'.html_safe, class: 'page-link', aria: {hidden: true})
      end
    end

    start_page = [page - 2, 1].max
    end_page = [page + 2, total_pages].min

    (start_page..end_page).each do |p|
      if p == page
        html += content_tag(:li, class: 'page-item active', aria: {current: 'page'}) do
          content_tag(:span, p, class: 'page-link')
        end
      else
        html += content_tag(:li, class: 'page-item') do
          link_to p, admin_redis_path(page: p, pattern: params[:pattern], namespace: params[:namespace]), class: 'page-link'
        end
      end
    end

    if page < total_pages
      html += content_tag(:li, class: 'page-item') do
        link_to '&raquo;'.html_safe, admin_redis_path(page: page + 1, pattern: params[:pattern], namespace: params[:namespace]), class: 'page-link', aria: {label: 'Next'}
      end
    else
      html += content_tag(:li, class: 'page-item disabled') do
        content_tag(:span, '&raquo;'.html_safe, class: 'page-link', aria: {hidden: true})
      end
    end

    html += '</ul>'
    html.html_safe
  end
end
