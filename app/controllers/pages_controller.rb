class PagesController < ApplicationController
  def welcome_guide
    authorize :page, :welcome_guide?

    @featured_categories = Category.featured
  end
end
