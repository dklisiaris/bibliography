class PagesController < ApplicationController
  def welcome_guide
    authorize :page, :welcome_guide?
  end
end
