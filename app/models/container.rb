class Container < ApplicationRecord
  has_many :crops
  validates_presence_of :name

  default_scope {order("containers.name ASC")}
  scope :order_by_name, -> (name) {order("containers.name #{name}")}

  def self.load(page = 1, per_page = 10)
    includes( crops: [:container, :product, :producer]).paginate(:page => page, :per_page => per_page)
  end

  def self.by_id(id)
    includes( crops: [:container, :product, :producer]).find_by({id: id})
  end

  def self.by_ids(ids, page = 1, per_page = 10)
    load(page, per_page).where(containers:{id: ids})
  end

  def self.by_crop(crop_id, page = 1, per_page = 10)
    load(page, per_page).where(crops:{id: crop_id})
  end

end
