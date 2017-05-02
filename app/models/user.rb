class User < ApplicationRecord
  include Localizable

  validates_presence_of :username
  validates_presence_of :password
end
