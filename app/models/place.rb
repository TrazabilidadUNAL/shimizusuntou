class Place < ApplicationRecord
  has_many :producers
  has_many :origins, class_name: 'Route', foreign_key: :origin_id
  has_many :destinations, class_name: 'Route', foreign_key: :destination_id

  validates_presence_of :tag
  validates_presence_of :lat
  validates_presence_of :lon
end
