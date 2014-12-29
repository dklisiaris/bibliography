class AuthorAward < ActiveRecord::Base
  belongs_to :author
  belongs_to :prize

  default_scope { order('year DESC') }
end
