class RouteLogSerializer < ActiveModel::Serializer
  attributes :id, :temperature, :humidity, :lat, :lon
end
