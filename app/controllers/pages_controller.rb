# frozen_string_literal: true

class PagesController < ApplicationController # :nodoc:
  def welcome_guide
    authorize :page, :welcome_guide?

    @featured_categories = Category.featured.order(:name)
  end

  def privacy_policy
    authorize :page, :privacy_policy?
  end

  def about
    authorize :page, :about?
  end
end
