class RouteLog < ApplicationRecord
  belongs_to :route

  validates_presence_of :temperature
  validates_presence_of :humidity
  validates_presence_of :lat
  validates_presence_of :lonq
end
