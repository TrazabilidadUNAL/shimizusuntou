module Api::V1
  class ContainersController < ApplicationController
    before_action :set_container, only: [:show, :update, :destroy]

    # GET /containers
    def index
      @containers = Container.all
      json_response(@containers)
    end

    # GET /containers/:id
    def show
      json_response(@container)
    end

    # POST /containers
    def create
      @container = Product.create!(container_params)
      json_response(@container, :created)
    end

    # PUT /containers/:id
    def update
      @container.update(container_params)
      head :no_content
    end

    # DELETE /containers/:id
    def destroy
      @container.destroy
      head :no_content
    end

    private

    def container_params
      params.permit(:name)
    end

    def set_container
      @container = Container.find(params[:id])
    end
  end
end
