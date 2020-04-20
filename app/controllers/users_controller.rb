class UsersController < ApplicationController
  protect_from_forgery

  def index
    render json: User.all
  end

  def show
    render json: user
  end

  def create
    render json: User.create!(user_params)
  end

  def update
    user.update!(user_params)
    render json: user
  end

  def destroy
    destroyed_user = user.destroy!
    render json: destroyed_user
  end

  private

  def user
    User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :username,
      :email,
      :password
    )
  end
end
