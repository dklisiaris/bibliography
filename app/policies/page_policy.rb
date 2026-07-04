# frozen_string_literal: true

class PagePolicy < ApplicationPolicy
  def welcome_guide?
    registered?
  end

  def privacy_policy?
    true
  end

  def about?
    true
  end

  def contact?
    true
  end
end
