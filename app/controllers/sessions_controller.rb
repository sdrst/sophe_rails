class SessionsController < ApplicationController
  protect_from_forgery
  # logins in user
  def login
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      time = Time.now + 24.hours.to_i
      render json: {
        token: token,
        exp: time.strftime("%m-%d-%Y %H:%M"),
        user: {
          username: user.username,
          email: user.email
          }
        }, status: :ok
    # in case authentication failed
    else
      render json: { msg: 'authentication failed' }, status: :unauthorized
    end
  end
end
