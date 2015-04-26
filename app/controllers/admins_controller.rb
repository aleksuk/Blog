class AdminsController < ApplicationController

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

  def edit_user
    @user = User.find(user_params[:id])

    if @user.update(user_params)
      render partial: 'user', locals: { user: @user }
    else
      render json: @user.errors.full_messages, status: 422
    end
  end

  private

  def user_params
    params.required(:user).permit(:id, :name, :email, :role_id)
  end

end
