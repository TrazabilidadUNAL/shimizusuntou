class PlaceSerializer < ActiveModel::Serializer
  attributes :id, :tag, :lat, :lon
end
