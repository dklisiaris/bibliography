# frozen_string_literal: true

class PagePolicy < Struct.new(:user, :page) # :nodoc:
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

  private

  def registered?
    user.present?
  end
end
