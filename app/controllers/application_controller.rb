class ApplicationController < ActionController::Base
  helper_method :current_user

  # ensure that the protected routes require authorization
  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    begin
      @current_user = User.find(
        JsonWebToken.decode(token)[:user_id]
      )
    rescue ActiveRecord::RecordNotFound => e
      render json: { msg: e.message }, status: :unauthorized
    rescue JWT::ExpiredSignature => e
      render json: { msg: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { msg: e.message }, status: :unauthorized
    end
  end
end
