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
    destroy_places(self.places)
    update_attribute(:show, false)
  end

  private

  def destroy_places(places)
    places.each do |place|
      place.destroy
    end
  end
end
