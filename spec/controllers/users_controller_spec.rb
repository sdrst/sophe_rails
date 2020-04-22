require 'rails_helper'
require './spec/support/controller_helpers'

RSpec.configure do |c|
  c.include ControllerHelpers
end

RSpec.describe UsersController, type: :controller do
  let!(:new_user_params) do
    {
      username: "johnny_boast",
      password: "hashed_password",
      password_confirm: "hashed_password",
      email: "bob@mail.com"
    }
  end
  let(:new_user_params_mistached_passwords) do
    {
      username: "johnny_boast",
      password: "hashed_password",
      password_confirm: "hashed_password_not",
      email: "bob@mail.com"
    }
  end
  let(:create_user_params) do
    {
      username: "johnnfy_boast",
      password: "hashed_password",
      email: "bob@mail.com"
    }
  end
  let(:update_user_params) do
    {
      username: "johnny_boasting",
    }
  end
  let!(:first_user) do
    User.create!(
      username: "eric_boast",
      password: "hashed_password",
      email: "bobby@mail.com"
    )
  end
  let(:dirty_user_params) do
    {
      username: "eric_boast",
      password: "hashed_password",
      password_confirm: "hashed_password",
      email: "bobby@mail.com",
      here: "pal"
    }
  end
  let!(:token) {
    JsonWebToken.encode(user_id: first_user.id)
  }

  context "protects the right routes" do
    it "protects put" do
      put :update, params: { id: first_user.id, user: update_user_params }
      expect_response_to_error_with("Nil JSON web token", 401)
    end

    it "protects patch" do
      patch :update, params: { id: first_user.id, user: update_user_params }
      expect_response_to_error_with("Nil JSON web token", 401)
    end

    it "protects update" do
      delete :destroy, params: { id: first_user.id }
      expect_response_to_error_with("Nil JSON web token", 401)
    end
  end

  it "returns a success response" do
    get :index, params: new_user_params
    expect(response).to be_successful
  end

  it "returns a success response" do
    get :show, params: { id: first_user.id }
    expect(response).to be_successful
  end

  context "post requests" do
    it "creates a new user when passwords match" do
      expect {
        post :create, params: { user: new_user_params }
      }.to change(User, :count).by(1)
    end

    it "does not creates a new user when passwords do not match" do
      expect {
        post :create, params: { user: new_user_params_mistached_passwords }
      }.to change(User, :count).by(0)
    end

    it "returns the created user with the right fields" do
      post :create, params: { user: new_user_params }
      expect(response.body).to eq({
        user: User.last.as_json(except: [:hashed_password])
      }.to_json)
    end

    it "returns an error when passwords do not match" do
      post :create, params: { user: new_user_params_mistached_passwords }
      expect_response_to_error_with("Passwords do not match")
    end

    it "returns ignores superfluous fields" do
      expect_any_instance_of(
        UsersController
      ).to receive(:create_params).and_return(create_user_params)
      post :create, params: { user: dirty_user_params }
    end

    it "returns error when an user with the fields email and username exist" do
      User.create!(create_user_params)
      post :create, params: { user: new_user_params }
      expect_response_to_error_with("username or email already used")
    end
  end

  context "put/patch requests" do
    before do
      request.headers["Authorization"] = "token #{token}"
    end

    it "updates the first user with put" do
      put :update, format: :json, params: { id: first_user.id, user: update_user_params }
      expect(
        JSON.parse(response.body)["name"]
      ).to eq(update_user_params[:name])
    end

    it "updates the first user with patch" do
      patch :update, format: :json, params: { id: first_user.id, user: update_user_params }
      expect(
        JSON.parse(response.body)["name"]
      ).to eq(update_user_params[:name])
    end

    it "returns ignores superfluous fields" do
      expect_any_instance_of(
        UsersController
      ).to receive(:update_params).and_return(create_user_params)
      put :update, format: :json, params: { id: first_user.id, user: update_user_params }
    end
  end

  context "delete requests" do
    before do
      request.headers["Authorization"] = "token #{token}"
    end

    it "destroys the first user with delete" do
      expect {
        delete :destroy, format: :json, params: { id: first_user.id }
      }.to change(User, :count).by(-1)
    end

    it "returns the destroyed user" do
      delete :destroy, format: :json, params: { id: first_user.id }
      expect(
        response.body
      ).to eq(first_user.to_json(except: [:hashed_password]))
    end
  end
end
