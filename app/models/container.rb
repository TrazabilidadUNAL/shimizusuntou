class Container < ApplicationRecord
  has_many :crops
  validates_presence_of :name
end
