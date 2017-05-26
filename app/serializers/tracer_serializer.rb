class TracerSerializer < ActiveModel::Serializer
  attributes :quantity
  has_one :product
  has_one :crop
  has_one :route
end