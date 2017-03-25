class Place < ApplicationRecord
  validates_presence_of :tag
  validates_presence_of :lat
  validates_presence_of :lon
end
