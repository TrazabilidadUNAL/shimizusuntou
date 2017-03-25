class Producer < ApplicationRecord
  belongs_to :place
  has_many :crops

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :username
  validates_presence_of :password
end
