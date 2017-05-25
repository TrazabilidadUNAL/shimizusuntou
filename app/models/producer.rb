class Producer < User

  has_many :crops

  validates_presence_of :first_name
  validates_presence_of :last_name

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
    self.places.update_all(show: false)
    update_attribute(:show, false)
  end

end
