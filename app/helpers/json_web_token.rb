class JsonWebToken
  SECRET_KEY = Rails.application.credentials.secret_key_base

  def self.encode(payload, exp = (7.days.from_now))
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    HashWithIndifferentAccess.new(JWT.decode(token, SECRET_KEY).first)
  end
end
