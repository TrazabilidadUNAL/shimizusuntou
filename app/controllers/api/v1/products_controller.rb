module Api::V1
  class ProductsController < ApplicationController
    before_action :set_product, only: [:show, :update, :destroy]

    def_param_group :product do
      param :name, String, 'Product name', :required => true
    end

    # GET /products
    api :GET, '/products', 'Show all products'
    description 'Retrieves the whole list of products in the system'
    formats ['json']
    example <<-EOS
    {
    "data": [
        {
            "id": 317, 
            "name": "90 Minute IPA"
        }, 
        {
            "id": 27, 
            "name": "90 Minute IPA"
        }, 
        {
            "id": 289, 
            "name": "90 Minute IPA"
        }
      ]
    }
    EOS
    def index
      @products = Product.where(show: true)
      json_response(@products)
    end

    # GET /products/:id
    api!
    def show
      json_response(@product)
    end

    # POST /products
    api!
    param_group :product
    def create
      @product = Product.create!(product_params)
      json_response(@product, :created)
    end

    # PUT /products/:id
    api!
    def update
      @product.update(product_params)
      head :no_content
    end

    # DELETE /products/:id
    api!
    def destroy
      @product.show = false
      @product.save!
      head :no_content
    end

    private

    def product_params
      params.permit(:name)
    end

    def set_product
      @product = Product.where(show: true).find(params[:id])
    end
  end
end