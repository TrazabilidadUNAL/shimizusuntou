class Package < ApplicationRecord
  belongs_to :crop
  belongs_to :route
  belongs_to :parent, class_name: 'Package'
  # has_many :packages, class_name: 'Package', foreign_key: :parent_id

  validates_presence_of :quantity
end
