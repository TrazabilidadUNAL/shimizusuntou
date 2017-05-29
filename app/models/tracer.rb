class Tracer < Package
  has_one :product

  def product
    Product.by_id(self.crop.product_id)
  end

  def container
    Container.by_id(self.crop.container_id)
  end
end