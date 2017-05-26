class CropLogSerializer < ActiveModel::Serializer
  attributes :id, :description, :created_at

  belongs_to :crop
end
