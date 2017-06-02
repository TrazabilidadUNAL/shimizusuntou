class PackageSerializer < ActiveModel::Serializer
  attributes :id, :parent_id, :quantity, :qr_code
  belongs_to :crop
  belongs_to :route
end
