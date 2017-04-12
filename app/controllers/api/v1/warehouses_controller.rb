module Api::V1
  class WarehousesController < ApplicationController

    before_action :set_warehouse, only: [:show, :update, :destroy]

    # GET /warehouses/:id
    def show
      json_response(@warehouse)
    end

    # POST /warehouses
    def create
      @warehouse = Warehouse.create!(warehouse_params)
      json_response(@warehouse, :created)
    end

    # PUT /warehouses/:id
    def update
      @warehouse.update(warehouse_params)
      head :no_content
    end

    # DELETE /warehouses/:id
    def destroy
      @warehouse.destroy
      head :no_content
    end

    private

    def warehouse_params
      params.permit(:place_id, :name, :username, :password)
    end

    def set_warehouse
      @warehouse = Warehouse.where(show: true).find(params[:id])
    end
  end
end
