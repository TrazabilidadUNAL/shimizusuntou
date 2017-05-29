class CropSerializer < ActiveModel::Serializer
  attributes :id, :sow_date, :harvest_date

  has_one :container
  has_one :product
  has_many :crop_logs
end
