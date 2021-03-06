class HomeController < ApplicationController
  skip_after_action :verify_policy_scoped, only: :index
  skip_after_action :verify_authorized,  except: :index
  before_action :set_owned_ids
  before_action :set_rated_ids

  def index
    @popular_books = Book.get_popular
    @latest_books = Book.get_latest
    @recommended_books = Book.top(count: 8)

    @awarded_books = Book.get_random_awarded

    @awarded_authors = Author.get_random_awarded

    @book_of_the_day = DailySuggestion.get_book_of_the_day_cached

    if user_signed_in?
      @shelves = current_user.shelves
      @recently_added = current_user.bookshelves
        .select("bookshelves.book_id")
        .group('bookshelves.book_id')
        .order('max(bookshelves.created_at) desc')
        .limit(6)
        .map {|bookshelf| bookshelf.book}

      @recommended_for_you = current_user.recommended_books_cached

      @people_to_follow = current_user.people_to_follow

      @activities =
        PublicActivity::Activity.where(owner: current_user.following_users.pluck(:id), trackable_type: 'Book')
                                .includes({ owner: :profile }, trackable: :main_writer).order(updated_at: :desc).page(params[:page]).per(8)
    end
  end

  def search
    if params[:q].present?
      keyphrase = ApplicationController.helpers.latinize(params[:q])

      limit = params[:autocomplete].try(:to_i) == 1 ? 8 : 25
      multi_search_options = {
        body_options: {min_score: 0.1},
        order: {_score: :desc},
        page: 1,
        per_page: limit,
        execute: false
      }
      single_search_options = multi_search_options.merge({
        page: params[:page],
        execute: true
      })

      case params[:search_only]
      when 'books'
        @books = Book.search(keyphrase, single_search_options)
      when 'authors'
        @authors = Author.search(keyphrase, single_search_options)
      when 'publishers'
        @publishers = Publisher.search(keyphrase, single_search_options)
      when 'categories'
        @categories = Category.search(keyphrase, single_search_options)
      when 'series'
        @series = Series.search(keyphrase, single_search_options)
      else
        book_search       = Book.search(keyphrase, multi_search_options)
        author_search     = Author.search(keyphrase, multi_search_options)
        publisher_search  = Publisher.search(keyphrase, multi_search_options)
        category_search   = Category.search(keyphrase, multi_search_options)
        series_search     = Series.search(keyphrase, multi_search_options)

        @search_results = Searchkick.multi_search([
          book_search, author_search, publisher_search, category_search, series_search
        ])

        # Hash containing num of hits per search type ie. {"Book"=>2, "Author"=>5}
        @search_hits = Hash[@search_results.map{|r| [r.klass.to_s, r.response["hits"]["total"]]}]

        @liked_author_ids = current_user.liked_author_ids if current_user.present?
      end

      if params[:autocomplete].try(:to_i) == 1
        render json: Api::V1::Preview::ResultsSerializer.new(@search_results)
      end
    else
      redirect_to root_path
    end
  end

  def autocomplete
    autocomplete_results = Book.search(params[:q], autocomplete: true, limit: 10).map(&:title)
    render json: autocomplete_results
  end

  private
  def set_owned_ids
    @owned_book_ids = current_user.book_ids if user_signed_in?
  end

  def set_rated_ids
    if user_signed_in?
      @liked_book_ids = current_user.liked_book_ids
      @disliked_book_ids = current_user.disliked_book_ids
    end
  end

end
