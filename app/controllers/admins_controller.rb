class AdminsController < ApplicationController

  before_filter :check_permission

  def show
    @users = User.page(1).per(10)
    @articles = Article.page(1).per(10)
  end

  def change_users
    @users = User.page(params[:page]).per(10)
    render partial: 'users'
  end

  def change_articles
    @articles = Article.page(params[:page]).per(10)
    render partial: 'articles'
  end

end
