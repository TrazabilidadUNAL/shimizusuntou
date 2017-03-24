class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :destroy]

  # GET /products
  def index
    @products = Product.all
    json_response(@products)
  end

  # GET /products/:id
  def show
    json_response(@product)
  end

  # POST /product
  def create
    @product = Product.create!(product_params)
    json_response(@product, :created)
  end

  # PUT /products/:id
  def update
    @product.update(product_params)
    head :no_content
  end

  # DELETE /products/:id
  def destroy
    @product.destroy
    head :no_content
  end

  private

  def product_params
    params.permit(:name)
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
