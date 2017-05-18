class User < ApplicationRecord
  include Localizable

  validates_presence_of :username
  validates_presence_of :password

  def generate_auth_token
    token = SecureRandom.hex
    self.update_column(:auth_token, token)
    token
  end

  def invalidate_auth_token
    self.update_column(:auth_token, nil)
  end

  def valid_password?(psswrd)
    self.password == psswrd
  end
end
