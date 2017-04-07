class CropSerializer < ActiveModel::Serializer
  attributes :id, :sow_date, :harvest_date, :container_id, :product_id, :producer_id
  has_many :crop_logs
end
