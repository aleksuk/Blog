class ArticlesController < ApplicationController

  skip_before_filter :authenticate_user!, only: [:index, :show]
  before_action :check_permission, except: [:index, :show]

  def index
    @articles = Article.order(:created_at).page(params[:page]).per(10)
    @pagination = @articles
  end

  def show
    @article = Article.find(params[:id])
    @comments = @article.comments.reverse_order
    @comment = Comment.new
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      render plain: article_path(@article)
    else
      render status: 422, json: @article.errors.full_messages
    end
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      render plain: article_path(@article)
    else
      render status: 422, json: @article.errors.full_messages
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to articles_path
  end

  private

  def article_params
    params.require(:article).permit(:title, :content, :label)
  end

end
