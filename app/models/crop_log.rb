class CropLog < ApplicationRecord
  belongs_to :crop

  validates_presence_of :description
end
