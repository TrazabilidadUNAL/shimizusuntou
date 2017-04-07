class RouteSerializer < ActiveModel::Serializer
  attributes :id, :origin_id, :destination_id
  has_many :route_logs
end
