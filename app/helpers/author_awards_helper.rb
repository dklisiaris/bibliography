module AuthorAwardsHelper
  def setup_award(author, award)
    award = award.nil? ? author.author_awards.new : award
  end
end
