class User < ApplicationRecord
  has_many :places, -> {where(show: true)}, as: :localizable

  validates_presence_of :username
  validates_presence_of :password
end
