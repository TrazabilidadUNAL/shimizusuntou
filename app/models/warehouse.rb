class Warehouse < User

  alias_attribute :name, :first_name

  validates_presence_of :name
  validates_presence_of :username
  validates_presence_of :password

  default_scope {order("users.first_name ASC")}
  scope :order_by_name, -> (type) {order("users.first_name #{type}")}

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
