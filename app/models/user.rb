require 'bcrypt'

class User < ApplicationRecord
  has_secure_password

  validates :username, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, presence: true
end
