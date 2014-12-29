class AuthorAward < ActiveRecord::Base
  belongs_to :author
  belongs_to :prize
end
