require "rails_helper"

RSpec.describe User, type: :model do
  let(:username) { "johnny_boast" }
  let(:password) { "hashed_password" }
  let(:email) { "bob@mail.com" }
  let(:user_params) do
    {
      username: username,
      email: email,
      password: password
    }
  end
  let(:user) { User.new(user_params) }

  it "sets the fields properly" do
    expect(user.username).to eq(username)
    expect(user.email).to eq(email)
    expect(user.password).to eq(password)
  end

  it "validates email" do
    new_user = User.new(
      username: username,
      email: "invalid",
      password: password
    )
    expect { new_user.save! }.to raise_exception(
      ActiveRecord::RecordInvalid,
      "Validation failed: Email is invalid"
    )
  end

  it "validates the presence of each field" do
    [:username, :email, :password].each do |field|
      new_user = User.new(user_params.except(field))
      expect { new_user.save! }.to raise_exception(
        ActiveRecord::RecordInvalid
      )
    end
  end
end
