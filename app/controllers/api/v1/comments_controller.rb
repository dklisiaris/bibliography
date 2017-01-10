class Api::V1::CommentsController < Api::V1::BaseController
  before_filter :authenticate_user_from_token!, only: [:create]
  before_action :set_book

  def index
    # @book = Book.find(params[:book_id])
    comments = @book.comment_threads
    comments = policy_scope(comments)

    render(
      json: comments,
      each_serializer: Api::V1::CommentSerializer,
      root: 'comments'
    )
  end

  def show
    # @book = Book.find(params[:book_id])
    comment = @book.comment_threads.find(params[:id])

    response = apply_format(Api::V1::CommentSerializer.new(comment))

    render(json: response)
  end

  def create
    comment = Comment.build_from( @book, current_user.id, create_params[:body] )
    if comment.save!
      if(create_params[:parent_id].present?)
        parent = Comment.find(create_params[:parent_id])
        comment.move_to_child_of(parent) unless parent.nil?
      else
        @book.create_activity :review, owner: current_user
      end
      render(json: {
        comment: {
          id: comment.id,
          body: create_params[:body],
          parent_id: create_params[:parent_id],
          user: {
            id: current_user.id,
            name: current_user.screen_name,
            image: current_user.avatar
          },
          message: 'ok' }
        }
      )
    else
      render(json: {comment: { message: 'fail' }})
    end
  end

  def destroy
    comment = @book.comment_threads.find(params[:id])
    if comment.destroy
      activity = current_user.activities.find_by(key: "book.review", trackable: @book)
      activity.destroy if activity.present?
      render(json: {message: 'ok'})
    else
      render(json: {message: 'fail'})
    end
  end

  private

  def set_book
    @book = Book.find(params[:book_id])
  end

  def create_params
    params.require(:comment).permit(:body, :parent_id)
  end
  # def set_award
  #   @award = Award.find(params[:id])
  #   authorize @award
  # end

end
