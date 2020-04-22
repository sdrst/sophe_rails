require 'rails_helper'
require './spec/support/controller_helpers'

RSpec.configure do |c|
  c.include ControllerHelpers
  c.include ActiveSupport::Testing::TimeHelpers
  c.infer_base_class_for_anonymous_controllers = false
end


RSpec.describe ApplicationController, type: :controller do
  let(:username) { "johnny_boast" }
  let(:password) { "hashed_password" }
  let(:email) { "bob@mail.com" }
  let!(:token) {
    JsonWebToken.encode(user_id: user.id)
  }
  let(:login_params) do
    {
      email: email,
      password: password
    }
  end
  let(:bad_login_params) do
    {
      email: email,
      password: "bad_password"
    }
  end
  let!(:user) do
    User.create!({
      username: username,
      email: email,
      password: password
    })
  end
  let(:ok) { "ok" }

  controller do
    before_action :authorize_request, except: :create

    def index
      render json: "ok"
    end
  end

  it "returns an error when token is not present" do
    get :index
    expect_response_to_error_with("Nil JSON web token", 401)
  end

  it "authorizes user when token is valid" do
    request.headers["Authorization"] = "token #{token}"
    get :index, format: :json
    expect(response.body).to eq(ok)
  end

  it "returns an error when token is expired" do
    travel_to Time.local(2016)
    request.headers["Authorization"] = "token #{JsonWebToken.encode(user_id: user.id)}"
    travel_back

    get :index, format: :json
    expect_response_to_error_with("Signature has expired", 401)
  end

  it "returns an error when token is invalid" do
    request.headers["Authorization"] = "token atop"

    get :index, format: :json
    expect_response_to_error_with("Not enough or too many segments", 401)
  end
end
