module Api::V1
  class ProductsController < ApplicationController
    before_action :set_product, only: [:show, :update, :destroy]

    has_scope :q, only: :index

    resource_description do
      desc <<-EOD
      Products available in the system.

      These Products are essential to set a Crop.

      The Products also relates to the Producers and Warehouses and can give an statistic of what and how they are dealing with them.

      Currently products are only created and edited by admin staff.
      EOD
    end

    def_param_group :product do
      param :name, String, "Product's name", :required => true
      param :image_url, String, "Product's image url"
      param :description, String, "Product's short description"
    end

    api! 'Shows all products'
    description 'General: Shows all the products available in the system. For users: Shows all the products for a certain user.'
    formats ['json']
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM
    GET /v1/products HTTP/1.1
    Accept: */*
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=60c0aefdd4324b5a92c5f7ea83e757df
    Connection: keep-alive
    
    
    
    HTTP/1.1 200 OK
    Cache-Control: max-age=0, private, must-revalidate
    Content-Type: application/json; charset=utf-8
    ETag: W/"c63fa87f58d25b4801582d9dfbe66688"
    Transfer-Encoding: chunked
    Vary: Origin
    X-Request-Id: 0d8127e2-289f-466a-8335-9d4b2e5a907a
    X-Runtime: 0.006565
    
    {
        "data": [
            {
                "description": "Tomacco was originally a fictional plant that was a hybrid between tomatoes and tobacco, from a 1999 episode of The Simpsons titled 'E-I-E-I-(Annoyed Grunt)'. The method used to create the tomacco in the episode is fictional. In the episode, the tomacco was accidentally created by Homer Simpson when he planted and fertilized his tomato and tobacco fields with plutonium. The result is a tomato that apparently has a dried, brown tobacco center, and, although being described as tasting terrible by many characters, is also immediately and powerfully addictive. The creation is promptly labeled 'tomacco' by Homer and sold in large quantities to unsuspecting passersby. A cigarette company, Laramie Tobacco Co., seeing the opportunity to legally sell their products to children, offers to buy the rights to market tomacco, but Homer demands one thousand times as much money as they wish to pay him, and the company withdraws. Eventually, all of the tomacco plants are eaten by farm animals — except for the one remaining plant, which later goes down in an explosive helicopter crash with the cigarette company's lawyers. - From https://en.wikipedia.org/wiki/Products_produced_from_The_Simpsons#Tomacco", 
                "id": 1, 
                "image_url": "http://2.media.bustedtees.cvcdn.com/c/-/bustedtees.f878919c-e3ae-4eba-b8e3-52b300cb.gif", 
                "name": "Tomacco"
            }
        ]
    }
    EOM

    def index
      if direct?
        @products = apply_scopes(Product).order(ordering_params(params)).all
      else
        @products = apply_scopes(current_user.products).order(ordering_params(params)).all
      end
      json_response(@products)
    end

    api! 'Shows an specific product'
    description 'Retrieves a single product in the system.'
    formats ['json']
    error :code => 404, :desc => "Product with that id hasn't been found"
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM
    GET /v1/products/1 HTTP/1.1
    Accept: */*
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=60c0aefdd4324b5a92c5f7ea83e757df
    Connection: keep-alive
    
    
    
    HTTP/1.1 200 OK
    Cache-Control: max-age=0, private, must-revalidate
    Content-Type: application/json; charset=utf-8
    ETag: W/"58a172909b5e07c27fff31a63bf0f347"
    Transfer-Encoding: chunked
    Vary: Origin
    X-Request-Id: f5c3e14d-4a08-43a9-95b6-d5834f788513
    X-Runtime: 0.014004
    
    {
        "data": {
            "description": "Tomacco was originally a fictional plant that was a hybrid between tomatoes and tobacco, from a 1999 episode of The Simpsons titled 'E-I-E-I-(Annoyed Grunt)'. The method used to create the tomacco in the episode is fictional. In the episode, the tomacco was accidentally created by Homer Simpson when he planted and fertilized his tomato and tobacco fields with plutonium. The result is a tomato that apparently has a dried, brown tobacco center, and, although being described as tasting terrible by many characters, is also immediately and powerfully addictive. The creation is promptly labeled 'tomacco' by Homer and sold in large quantities to unsuspecting passersby. A cigarette company, Laramie Tobacco Co., seeing the opportunity to legally sell their products to children, offers to buy the rights to market tomacco, but Homer demands one thousand times as much money as they wish to pay him, and the company withdraws. Eventually, all of the tomacco plants are eaten by farm animals — except for the one remaining plant, which later goes down in an explosive helicopter crash with the cigarette company's lawyers. - From https://en.wikipedia.org/wiki/Products_produced_from_The_Simpsons#Tomacco", 
            "id": 1, 
            "image_url": "http://2.media.bustedtees.cvcdn.com/c/-/bustedtees.f878919c-e3ae-4eba-b8e3-52b300cb.gif", 
            "name": "Tomacco"
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

    def create
      json_response(Product.create!(product_params), :created)
    end

    def update
      if @product
        @product.update(product_params)
        head :no_content
      else
        head :not_found
      end
    end

    def destroy
      if @product
        @product.destroy
        head :no_content
      else
        head :not_found
      end
    end

    private

    def product_params
      params.permit(:name, :image_url, :description)
    end

    def set_product
      if direct?
        @product = Product.find(params[:id])
      else
        @product = current_user.products.find(params[:id])
      end
    end

    def direct?
      if request.fullpath.split('/')[2] == 'products'
        return true
      end
      false
    end

  end
end