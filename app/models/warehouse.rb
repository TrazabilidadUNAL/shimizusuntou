class Warehouse < User

  alias_attribute :name, :first_name

  validates_presence_of :name

  default_scope {order("users.first_name ASC")}
  scope :order_by_name, -> (type) {order("users.first_name #{type}")}

  def self.by_id(id)
    load.find_by({id: id})
  end

  def self.by_place(place_id)
    load.where(places: {id: place_id})
  end

  def crops
    @crops = Array.new([])
    self.packages.each do |p|
      unless @crops.include?(p.crop)
        @crops.push(p.crop)
      end
    end
    Crop.by_ids (@crops)
  end

end
