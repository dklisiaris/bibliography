# frozen_string_literal: true

class BookCommentsController < ApplicationController
  before_action :set_json_format
  before_action :authenticate_user_from_token!
  before_action :set_book

  protect_from_forgery with: :exception, except: [:create, :destroy]

  def create
    comment = Comment.build_from(@book, current_user.id, comment_params[:body])
    authorize comment

    if comment.save!
      if comment_params[:parent_id].present?
        parent = Comment.find(comment_params[:parent_id])
        comment.move_to_child_of(parent) unless parent.nil?
      else
        @book.create_activity :review, owner: current_user
      end

      render json: { comment: comment_json(comment, message: 'ok') }
    else
      render json: { comment: { message: 'fail' } }
    end
  end

  def destroy
    comment = @book.comment_threads.find(params[:id])
    authorize comment

    if comment.destroy
      activity = current_user.activities.find_by(key: 'book.review', trackable: @book)
      activity.destroy if activity.present?
      render json: { message: 'ok' }
    else
      render json: { message: 'fail' }
    end
  end

  private

  def set_book
    @book = Book.find(params[:book_id])
  end

  def comment_params
    params.require(:comment).permit(:body, :parent_id)
  end

  def comment_json(comment, message:)
    {
      id: comment.id,
      body: comment_params[:body],
      parent_id: comment_params[:parent_id],
      user: {
        id: current_user.id,
        name: current_user.screen_name,
        image: current_user.avatar
      },
      message: message
    }
  end
end
