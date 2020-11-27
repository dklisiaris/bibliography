# frozen_string_literal: true

# == Schema Information
#
# Table name: genres
#
#  id           :bigint(8)        not null, primary key
#  name         :string
#  biblionet_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_genres_on_biblionet_id  (biblionet_id) UNIQUE
#


class Genre < ActiveRecord::Base
  has_many :books

  validates :name, presence: true
end
