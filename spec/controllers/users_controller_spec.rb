require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user_params) do
    {
      username: "johnny_boast",
      password: "hashed_password",
      email: "bob@mail.com"
    }
  end
  let(:updated_user_params) do
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
      email: "bobby@mail.com",
      here: "pal"
    }
  end

  let(:valid_session) { {} }

  it "returns a success response" do
    get :index, params: user_params, session: valid_session
    expect(response).to be_successful
  end

  it "returns a success response" do
    get :show, params: { id: first_user.id }, session: valid_session
    expect(response).to be_successful
  end

  context "post requests" do
    it "creates a new user" do
      expect {
        post :create, params: { user: user_params }, session: valid_session
      }.to change(User, :count).by(1)
    end

    it "returns the created user with the right fields" do
      post :create, params: { user: user_params }, session: valid_session
      expect(response.body).to eq(User.last.to_json)
    end

    it "returns ignores superfluous fields" do
      expect_any_instance_of(
        UsersController
      ).to receive(:user_params).and_return(user_params)
      post :create, params: { user: dirty_user_params }, session: valid_session
    end
  end

  context "put/patch requests" do
    it "updates the first user with put" do
      put :update, params: { id: first_user.id, user: updated_user_params }, session: valid_session
      expect(
        JSON.parse(response.body)["name"]
      ).to eq(updated_user_params[:name])
    end

    it "updates the first user with patch" do
      patch :update, params: { id: first_user.id, user: updated_user_params }, session: valid_session
      expect(
        JSON.parse(response.body)["name"]
      ).to eq(updated_user_params[:name])
    end

    it "returns ignores superfluous fields" do
      expect_any_instance_of(
        UsersController
      ).to receive(:user_params).and_return(user_params)
      put :update, params: { id: first_user.id, user: updated_user_params }, session: valid_session
    end
  end

  context "delete requests" do
    it "destroys the first user with delete" do
      expect {
        delete :destroy, params: { id: first_user.id }, session: valid_session
      }.to change(User, :count).by(-1)
    end

    it "returns the destroyed user" do
      delete :destroy, params: { id: first_user.id }, session: valid_session
      expect(
        response.body
      ).to eq(first_user.to_json)
    end
  end
end
