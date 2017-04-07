class Warehouse < ApplicationRecord

  default_scope {order("warehouses.name ASC")}
  scope :order_by_name, -> (type) {order("warehouses.name #{type}")}

  include Localizable

  validates_presence_of :name
  validates_presence_of :username
  validates_presence_of :password

  def self.load_warehouses(page = 1, per_page = 10)
    includes( :places ).paginate(:page => page, :per_page => per_page)
  end

  def self.warehouse_by_id(id)
    includes( :places ).find_by_id(id)
  end

  def self.warehouses_by_ids(ids, page = 1, per_page = 10)
    load_warehouses(page, per_page).where(warehouses:{id: ids})
  end

  def self.warehouses_by_not_ids(ids, page = 1, per_page = 10)
    load_warehouses(page, per_page).where.not(warehouses:{id: ids})
  end

  def self.warehouses_by_place(place, page = 1, per_page = 10)
    load_warehouses(page, per_page).where(places:{localizable_type: 'Warehouse', localizable_id: self.id})
  end
end
