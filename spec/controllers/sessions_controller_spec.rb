require 'rails_helper'
require './spec/support/controller_helpers'

RSpec.configure do |c|
  c.include ControllerHelpers
end

RSpec.describe SessionsController, type: :controller do
  let(:username) { "johnny_boast" }
  let(:password) { "hashed_password" }
  let(:email) { "bob@mail.com" }
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

  it "returns a token" do
    post :login, params: login_params
    expect(
      JsonWebToken.decode(
        JSON.parse(response.body)["token"]
      )
    ).to include(
      "exp",
      "user_id": user.id
    )
  end

  it "returns an error when credentials are bad" do
    post :login, params: bad_login_params
    expect_response_to_error_with("authentication failed", 401)
  end
end
