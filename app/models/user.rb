require 'bcrypt'

class User < ApplicationRecord
  include BCrypt

  validates :username, presence: true
  validates :password, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, presence: true

  def password=(new_password)
   super(BCrypt::Password.create(new_password).to_s)
 end
end
