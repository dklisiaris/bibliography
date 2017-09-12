require 'rails_helper'

RSpec.describe Series, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: series
#
#  id             :integer          not null, primary key
#  name           :string
#  books_count    :integer          default(0)
#  tsearch_vector :tsvector
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
