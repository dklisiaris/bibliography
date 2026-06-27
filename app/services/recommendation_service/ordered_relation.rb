# frozen_string_literal: true

class RecommendationService::OrderedRelation
  # Preserve ID order without interpolating into SQL (Brakeman-safe).
  def self.where_id_in_order(model, ids)
    ordered_ids = Array(ids).filter_map do |id|
      Integer(id)
    rescue ArgumentError, TypeError
      nil
    end.uniq

    return model.none if ordered_ids.empty?

    model.where(id: ordered_ids).in_order_of(:id, ordered_ids)
  end
end
