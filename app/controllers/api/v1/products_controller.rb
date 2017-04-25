module Api::V1
  class ProductsController < ApplicationController
    before_action :set_product, only: [:show, :update, :destroy]
    before_action :load_parent

    # GET /products
    def index
      @products = Product.where(show: true)
      json_response(@products)
    end

    # GET /products/:id
    def show
      json_response(@product)
    end

    # POST /products
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

    def load_parent
      if request.path.split('/')[2] != 'products'
        parent, id = request.path.split('/')[2, 2]
        @parentable = parent.singularize.classify.constantize.find(id)
        json_response(@parentable.products)
      end
    end

  end
end