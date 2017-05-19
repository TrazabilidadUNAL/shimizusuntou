class User < ApplicationRecord
  include Localizable

  validates_presence_of :username
  validates_presence_of :password

  def generate_auth_token
    token = SecureRandom.hex
    self.update_columns(auth_token: token, token_created_at: Time.zone.now)
    token
  end

  def invalidate_auth_token
    self.update_columns(auth_token: nil, token_created_at: nil)
  end

  def valid_password?(psswrd)
    self.password == psswrd
  end
end
