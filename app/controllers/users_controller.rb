class UsersController < ApplicationController
  protect_from_forgery
  before_action :authorize_request, except: [:index, :create, :show]

  def index
    render json: User.all
  end

  def show
    render json: user.jsonify
  end

  def create
    if params[:user][:password_confirm] == params[:user][:password]
      new_user = User.new(create_params)
      begin
        new_user.save!
        render json: {
          user: new_user.as_json(except: [:hashed_password])
        }
      rescue ActiveRecord::RecordNotUnique
        render json: { msg: "username or email already used" }, status: :unprocessable_entity
      rescue Exception
        render json: { msg: "unknown error" }, status: :unprocessable_entity
      end
    else
      render json: { msg: "Passwords do not match" }, status: :unprocessable_entity
    end

  end

  def update
    user.update!(update_params)
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

  def create_params
    params.require(:user).permit(
      :username,
      :email,
      :password
    )
  end

  def update_params
    params.require(:user).permit(
      :username,
      :email
    )
  end
end
