class ContainerSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :crops

end
