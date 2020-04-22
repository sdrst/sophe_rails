require 'rails_helper'

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

  let(:valid_session) { {} }

  it "returns a success response" do
    get :index, params: new_user_params, session: valid_session
    expect(response).to be_successful
  end

  it "returns a success response" do
    get :show, params: { id: first_user.id }, session: valid_session
    expect(response).to be_successful
  end

  context "post requests" do
    it "creates a new user when passwords match" do
      expect {
        post :create, params: { user: new_user_params }, session: valid_session
      }.to change(User, :count).by(1)
    end

    it "does not creates a new user when passwords do not match" do
      expect {
        post :create, params: { user: new_user_params_mistached_passwords }, session: valid_session
      }.to change(User, :count).by(0)
    end

    it "returns the created user with the right fields" do
      post :create, params: { user: new_user_params }, session: valid_session
      expect(response.body).to eq({
        user: User.last.as_json(except: [:hashed_password])
      }.to_json)
    end

    it "returns an error when passwords do not match" do
      post :create, params: { user: new_user_params_mistached_passwords }, session: valid_session
      expect(response.body).to eq({
        msg: "Passwords do not match"
      }.to_json)
    end

    it "returns ignores superfluous fields" do
      expect_any_instance_of(
        UsersController
      ).to receive(:create_params).and_return(create_user_params)
      post :create, params: { user: dirty_user_params }, session: valid_session
    end

    it "returns error when an user with the fields email and username exist" do
        User.create!(create_user_params)
        post :create, params: { user: new_user_params }, session: valid_session
        expect(response.body).to eq({
          msg: "username or email already used"
        }.to_json)
    end
  end

  context "put/patch requests" do
    it "updates the first user with put" do
      put :update, params: { id: first_user.id, user: update_user_params }, session: valid_session
      expect(
        JSON.parse(response.body)["name"]
      ).to eq(update_user_params[:name])
    end

    it "updates the first user with patch" do
      patch :update, params: { id: first_user.id, user: update_user_params }, session: valid_session
      expect(
        JSON.parse(response.body)["name"]
      ).to eq(update_user_params[:name])
    end

    it "returns ignores superfluous fields" do
      expect_any_instance_of(
        UsersController
      ).to receive(:update_params).and_return(create_user_params)
      put :update, params: { id: first_user.id, user: update_user_params }, session: valid_session
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
      ).to eq(first_user.to_json(except: [:hashed_password]))
    end
  end
end
