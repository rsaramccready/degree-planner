class UsersController < ApplicationController
  skip_before_action :require_authenticated_user, only: [:new, :create]

  def show
  end

  def new
    if current_user.present?
      redirect_to logged_in_path
    end
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to logged_in_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end
end
