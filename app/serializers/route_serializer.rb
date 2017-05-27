class RouteSerializer < ActiveModel::Serializer
  attributes :id

  belongs_to :origin
  belongs_to :destination

  has_many :route_logs
end
