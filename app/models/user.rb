class User < ApplicationRecord
  include Localizable

  validates_presence_of :username
  validates_presence_of :password
  validates_presence_of :email

  def generate_auth_token
    token = SecureRandom.hex
    self.update_columns(auth_token: token, token_created_at: Time.zone.now)
    token
  end

  def invalidate_auth_token
    self.update_columns(auth_token: nil, token_created_at: nil)
  end

  def valid_password?(psswrd)
    self.password == psswrd
  end

  def crops
  end

  def destroy
    self.places.update_all(show: false)
    update_attribute(:auth_token, nil)
    super
  end

  def products
    @products = Array.new([])
    self.crops.each do |crop|
      unless @products.include?(crop.product)
        @products.push(crop.product)
      end
    end
    Product.by_ids(@products)
  end

  def containers
    @containers = Array.new([])
    self.crops.each do |crop|
      unless @containers.include?(crop.container)
        @containers.push(crop.container)
      end
    end
    Container.by_ids(@containers)
  end

  def routes
    @routes = Array.new([])
    Route.by_origin(self.places).each do |r|
      @routes.push r
    end
    Route.by_destination(self.places).each do |r|
      @routes.push r
    end
    Route.by_ids(@routes)
  end

  def packages
    Package.by_routes(self.routes)
  end
end
