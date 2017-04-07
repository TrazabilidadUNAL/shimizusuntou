class PackageSerializer < ActiveModel::Serializer
  attributes :id, :parent_id, :crop_id, :route_id, :quantity
end
