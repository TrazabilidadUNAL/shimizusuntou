class Route < ApplicationRecord
  belongs_to :origin, class_name: 'Place'
  belongs_to :destination, class_name: 'Place'

  has_many :packages
end
