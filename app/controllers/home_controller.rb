class HomeController < ApplicationController
  skip_after_action :verify_policy_scoped, only: :index
  skip_after_action :verify_authorized,  except: :index

  def index
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

    if user_signed_in?
      @activities = PublicActivity::Activity
        .where(owner: current_user.following_users.pluck(:id))
        .includes({owner: :profile}, :trackable).order(updated_at: :desc)
    end
  end

  def search
    if params[:q].present?
      keyphrase = ApplicationController.helpers.latinize(params[:q])

      limit = params[:autocomplete].try(:to_i) == 1 ? 8 : 50
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
      else
        book_search       = Book.search(keyphrase, multi_search_options)
        author_search     = Author.search(keyphrase, multi_search_options)
        publisher_search  = Publisher.search(keyphrase, multi_search_options)
        category_search   = Category.search(keyphrase, multi_search_options)

        @search_results = Searchkick.multi_search([
          book_search, author_search, publisher_search, category_search
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

end
