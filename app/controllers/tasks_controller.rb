class TasksController < ApplicationController
  skip_after_action :verify_policy_scoped, only: :index

  def index
    authorize :task, :index?
  end

  def update_content
    authorize :task, :update_content?
    limit = params[:limit].to_i

    ContentUpdateWorker.perform_async(limit)

    flash[:notice] = t('tasks.content_updating_in_bg')
    redirect_to tasks_path
  end
end
