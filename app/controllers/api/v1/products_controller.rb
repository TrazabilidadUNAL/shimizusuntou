module Api::V1
  class ProductsController < ApplicationController
    before_action :set_product, only: [:show, :update, :destroy]

    resource_description do
      desc <<-EOD
      Products available in the system.

      These Products are essential to set a Crop.

      The Products also relates to the Producers and Warehouses and can give an statistic of what and how they are dealing with them.
      EOD
    end

    def_param_group :product do
      param :name, String, 'Product name', :required => true
    end

    api! 'Shows all products'
    description 'Retrieves the whole list of products in the system'
    formats ['json']
    example <<-EOM
    HTTP/1.1 200 OK
    Cache-Control: max-age=0, private, must-revalidate
    Content-Type: application/json; charset=utf-8
    ETag: W/"6a0c7e3f2e976bf46026ce615c506473"
    Transfer-Encoding: chunked
    Vary: Origin
    X-Content-Type-Options: nosniff
    X-Frame-Options: SAMEORIGIN
    X-Request-Id: 3d8a06b0-e358-4d84-9a79-84e0ec580377
    X-Runtime: 0.145334
    X-XSS-Protection: 1; mode=block
    {
        "data": [
            {
                "id": 196, 
                "name": "90 Minute IPA"
            }, 
            {
                "id": 382, 
                "name": "Westmalle Trappist Tripel"
            }, 
            {
                "id": 472, 
                "name": "Yeti Imperial Stout"
            }
        ]
    }
    EOM
    def index
      @products = Product.where(show: true)
      json_response(@products)
    end

    api! 'Shows an specific product'
    description 'Retrieves a single product in the system'
    formats ['json']
    example <<-EOM
    HTTP/1.1 200 OK
    Cache-Control: max-age=0, private, must-revalidate
    Content-Type: application/json; charset=utf-8
    ETag: W/"99d67fb04c806e1d4ef91a088c09164c"
    Transfer-Encoding: chunked
    Vary: Origin
    X-Content-Type-Options: nosniff
    X-Frame-Options: SAMEORIGIN
    X-Request-Id: e1011866-036f-4ba5-8a33-ce71c845b645
    X-Runtime: 0.004554
    X-XSS-Protection: 1; mode=block
    {
        "data": {
            "id": 13, 
            "name": "Oak Aged Yeti Imperial Stout"
        }
    }
    EOM
    def show
      json_response(@product)
    end

    api! 'Creates a new product'
    param_group :product
    error :code => 500, :desc => 'Internal server error', :meta => {:problem => 'Missing `name` parameter'}
    example <<-EOM
    HTTP/1.1 201 Created
    Cache-Control: max-age=0, private, must-revalidate
    Content-Type: application/json; charset=utf-8
    ETag: W/"ba27fb10b09efca048771a88c65d699e"
    Transfer-Encoding: chunked
    Vary: Origin
    X-Content-Type-Options: nosniff
    X-Frame-Options: SAMEORIGIN
    X-Request-Id: 12ff79b8-0a53-4ff0-8222-5ac162087d37
    X-Runtime: 0.035245
    X-XSS-Protection: 1; mode=block
    
    {
        "data": {
            "id": 501, 
            "name": "Indian Pale Ale"
        }
    }
    EOM
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