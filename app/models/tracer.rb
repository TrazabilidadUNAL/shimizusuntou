class Tracer < Package
  has_one :product

  def product
    Product.by_id(self.crop.product_id)
  end
end