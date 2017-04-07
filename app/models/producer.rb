class Producer < ApplicationRecord

  include Localizable
  has_many :crops

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :username
  validates_presence_of :password

  default_scope { order("producers.last_name ASC") }
  scope :order_by_last_name, -> (last) { order("producers.last_name #{last}") }

  def self.load
    includes(:places, crops: [:container, :product]).where(show: true)
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
