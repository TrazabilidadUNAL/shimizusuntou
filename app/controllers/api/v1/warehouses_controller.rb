module Api::V1
  class WarehousesController < ApplicationController
    skip_before_action :require_login!, only: [:create]
    before_action :set_warehouse, only: [:show, :update, :destroy]

    # GET /producers
    def index
      @warehouses = Warehouse.where(show: true)
      json_response(@warehouses)
    end

    # GET /warehouses/:id
    def show
      if @warehouse
        json_response(@warehouse)
      else
        json_response({:message => "Couldn't find Warehouse with id #{params[:id]}"}, :not_found)
      end
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
      @places = Place.where(localizable_type: 'Warehouse', localizable_id: @warehouse.id)
      @places.each do |place|
        place.show = false
        place.save!
      end
      @warehouse.show = false
      @warehouse.save!
      head :no_content
    end

    private

    def warehouse_params
      params.permit(:place_id, :name, :username, :password, :email)
    end

    def set_warehouse
      @warehouse = Warehouse.find(params[:id])
    end
  end
end
