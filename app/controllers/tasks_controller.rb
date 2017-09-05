class TasksController < ApplicationController
  skip_after_action :verify_policy_scoped, only: :index

  def index
    authorize :task, :index?

    @books_count = Book.all.count
    @authors_count = Author.all.count
    @publishers_count = Publisher.all.count
    @categories_count = Category.all.count
  end

  def update_content
    authorize :task, :update_content?
    limit = params[:limit].to_i

    ContentUpdateWorker.perform_async(limit)

    flash[:notice] = t('tasks.content_updating_in_bg')
    redirect_to tasks_path
  end

  def import_book_of_the_day_candidates
    authorize :task, :update_content?

    flash[:notice] = t('tasks.content_updating_in_bg')
    redirect_to tasks_path
  end
end
