module Api::V1
  class ProductsController < ApplicationController
    before_action :set_product, only: [:show, :update, :destroy]
    before_action :load_parent

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
    description 'Retrieves the whole list of products in the system. If there are not enough records an empty array is returned.'
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
      if params[:q].present?
        @products = Product.search(params[:q])
      end
      json_response(@products)
    end

    api! 'Shows an specific product'
    description 'Retrieves a single product in the system'
    formats ['json']
    error :code => 404, :desc => "Product with that id hasn't been found"
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
      if @product
        json_response(@product)
      else
        json_response({:message => "Couldn't find Product with id #{params[:id]}"}, :not_found)
      end
    end

    api! 'Creates a new product'
    description 'Creates a new product having its name as a parameter.'
    param_group :product
    error :code => 422, :desc => 'Unprocessable entity', :meta => {:problem => 'Missing `name` parameter'}
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

    api! 'Updates an existing product'
    description 'Updates an existing product.'
    param_group :product
    error :code => 404, :desc => "Product with that id hasn't been found"
    example <<-EOM
    HTTP/1.1 204 No Content
    Cache-Control: no-cache
    Vary: Origin
    X-Content-Type-Options: nosniff
    X-Frame-Options: SAMEORIGIN
    X-Request-Id: 5088731b-2133-4552-9aeb-bb35edebbcee
    X-Runtime: 0.024239
    X-XSS-Protection: 1; mode=block
    EOM

    def update
      if @product
        @product.update(product_params)
        head :no_content
      else
        head :not_found
      end
    end

    api! 'Deletes a product in the system'
    description 'Deletes a product in the system given an id.'
    error :code => 404, :desc => "Product with that id hasn't been found."
    example <<-EOM
    HTTP/1.1 204 No Content
    Cache-Control: no-cache
    Vary: Origin
    X-Content-Type-Options: nosniff
    X-Frame-Options: SAMEORIGIN
    X-Request-Id: 841effba-dbac-4dae-a52c-312d5cdc4d5f
    X-Runtime: 0.021002
    X-XSS-Protection: 1; mode=block
    EOM

    def destroy
      if @product
        @product.show = false
        @product.save!
        head :no_content
      else
        head :not_found
      end
    end

    private

    def product_params
      permitted = params.permit(:name)
    end

    def set_product
      @product = Product.find(params[:id])
    end

    def load_parent
      if request.path.split('/')[2] != 'products'
        parent, id = request.path.split('/')[2, 2]
        @parentable = parent.singularize.classify.constantize.find(id)
        json_response(@parentable.products)
      end
    end

  end
end