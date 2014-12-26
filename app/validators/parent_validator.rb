class ParentValidator < ActiveModel::Validator
  def validate(record)
    unless record.parent_id.nil? or Category.exists?(parent_id: record.parent_id)
      record.errors[:parent_id] << (options[:message] || "Parent doesn't exist.")
    end
  end
end