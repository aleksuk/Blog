class UsersController < ApplicationController

  def show
    @user = User.find(current_user.id)
  end

  def edit
    @user = current_user
  end

  def validate
    @user = User.new(user_params)

    if @user.valid?
      render plain: 'OK'
    else
      render json: @user.errors, status: 422
    end
  end

  private

  def user_params
    params.required(:user).permit(:name,
                                  :email,
                                  :password,
                                  :password_confirmation,
                                  :current_password)
  end

end
