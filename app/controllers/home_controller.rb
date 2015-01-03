class HomeController < ApplicationController
  skip_after_action :verify_policy_scoped, only: :index 

  def index    
    @search_results = Book.search(params[:search]).page(params[:page])
    @latest_books = Book.order(created_at: :desc).limit(5)   
  
  end

end
