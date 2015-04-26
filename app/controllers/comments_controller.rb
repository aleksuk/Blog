class CommentsController < ApplicationController

  before_filter :check_permission, only: [:destroy]
  skip_before_filter :authenticate_user!, only: [:create]

  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.create(comment_params.merge(user_id: get_user_id))

    check_xhr
  end

  def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    @comment.destroy

    check_xhr
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def get_user_id
    current_user.id if current_user
  end

  def check_xhr
    if request.xhr?
      render @comment
    else
      redirect_to article_path(@article)
    end
  end

end
