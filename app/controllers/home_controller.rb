class HomeController < ApplicationController
  skip_after_action :verify_policy_scoped, only: :index
  skip_after_action :verify_authorized,  except: :index 

  def index    
    @search_results = Book.search(params[:query], page: params[:page], per_page: 25, fields: [:title, :description]) if params[:query].present?
    @latest_books = Book.order(created_at: :desc).where.not(image: '').limit(6)   
    @shelves = current_user.shelves if user_signed_in?
    @recently_added = current_user.bookshelves.order(created_at: :desc).limit(12).map {|bookshelf| bookshelf.book} if user_signed_in?
  
  end

  def autocomplete
    autocomplete_results = Book.search(params[:query], autocomplete: true, limit: 10).map(&:title)    
    render json: autocomplete_results
  end  

end
