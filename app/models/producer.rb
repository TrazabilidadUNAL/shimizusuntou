class Producer < User

  has_many :crops

  validates_presence_of :first_name
  validates_presence_of :last_name

  default_scope { order("users.last_name ASC") }
  scope :order_by_last_name, -> (last) { order("users.last_name #{last}") }

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

  def products()
    @products = Array.new([])
    @crops = self.crops
    @crops.each do |crop|
      unless @products.include?(crop.product)
        @products.push(crop.product)
      end
    end
    Product.by_ids(@products)
  end

  def routes()
    Route.by_ids(self.places)
  end

  def packages()
    Package.by_routes(self.routes)
  end

end
