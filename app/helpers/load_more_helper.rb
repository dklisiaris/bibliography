module LoadMoreHelper
  def turbo_load_more_link(collection, **options)
    return unless collection.present? && collection.try(:next_page)

    link_to_next_page(
      collection,
      t("load_more"),
      **{
        class: "btn btn-block btn-primary",
        data: { turbo_stream: true },
      }.merge(options)
    )
  end
end
