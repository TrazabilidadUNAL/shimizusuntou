class RouteLogSerializer < ActiveModel::Serializer
  attributes :id, :temperature, :humidity, :lat, :lon, :created_at
  belongs_to :route
end
