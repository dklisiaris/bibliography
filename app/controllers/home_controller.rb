class HomeController < ApplicationController
  skip_after_action :verify_policy_scoped, only: :index
  skip_after_action :verify_authorized,  except: :index 

  def index    
    @search_results = Book.search(params[:query], page: params[:page], per_page: 25, fields: [:title, :description]) if params[:query].present?
    
    @popular_books = Book.order(impressions_count: :desc).limit(6)
    @latest_books = Book.order(created_at: :desc).where.not(image: '').limit(6)
    @recommended_books = Book.top(count: 6)    
     
    @awarded_books = Award.where(awardable_type: 'Book')
      .select('awards.awardable_id, awards.awardable_type, sum(awards.id) as awards_count')
      .group('awards.awardable_id, awards.awardable_type')
      .order('awards_count desc')
      .limit(6)
      .map {|award| award.awardable}


    @shelves = current_user.shelves if user_signed_in?
    @recently_added = current_user.bookshelves
      .select("bookshelves.book_id")
      .group('bookshelves.book_id')
      .order('max(bookshelves.created_at) desc')
      .limit(10)
      .map {|bookshelf| bookshelf.book} if user_signed_in?

  end

  def autocomplete
    autocomplete_results = Book.search(params[:query], autocomplete: true, limit: 10).map(&:title)    
    render json: autocomplete_results
  end  

end
