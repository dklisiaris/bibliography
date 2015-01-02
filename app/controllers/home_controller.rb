class HomeController < ApplicationController
  skip_after_action :verify_policy_scoped, only: :index 

  def index
    @latest_books = Book.order(created_at: :desc).limit(5)   
  
  end

end
