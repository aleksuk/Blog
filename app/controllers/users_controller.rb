class UsersController < ApplicationController

  before_filter :check_permission, only: [:update]

  def show
    @user = User.find(current_user.id)
  end

  def update
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
