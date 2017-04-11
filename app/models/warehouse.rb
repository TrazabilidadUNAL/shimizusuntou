class Warehouse < ApplicationRecord

  include Localizable

  validates_presence_of :name
  validates_presence_of :username
  validates_presence_of :password

  default_scope {order("warehouses.name ASC")}
  scope :order_by_name, -> (type) {order("warehouses.name #{type}")}

  def self.load
    includes(:places).where(show: true)
  end

  def self.by_id(id)
    load.find_by({id: id})
  end

  def self.by_place(place_id)
    load.where(places: {id: place_id})
  end

  def destroy
    self.places.update_all(show: false)
    update_attribute(:show, false)
  end

end
