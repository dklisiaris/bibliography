# frozen_string_literal: true

class Genre < ActiveRecord::Base
  has_many :books

  validates :name, presence: true
end
