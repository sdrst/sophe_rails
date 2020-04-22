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

  context "password hashing" do
    it "changes the password" do
      expect(user[:password]).not_to eq(password)
    end

    it "properly hashes the password" do
      is_password = true if BCrypt::Password.new(user[:password]) == password
      expect(is_password).to be true
    end
  end

  it "fields are unique and raise exceptions when they are not" do
    User.create(user_params)
    [:username, :email, :password].each do |field|
      new_user = User.new(user_params.except(field))

      new_user[field] = eval(field.to_s)

      expect { new_user.save! }.to raise_exception(
        ActiveRecord::RecordNotUnique
      )
    end
  end
end
