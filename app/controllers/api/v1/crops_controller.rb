module Api::V1
  class CropsController < ApplicationController
    before_action :set_crop, only: [:show, :update, :destroy]

    # GET /crops
    def index
      @crops = Crop.all
      json_response(@crops)
    end

    # GET /crops/:id
    def show
      json_response(@crop)
    end

    # POST /crops
    def create
      @crop = Crop.create!(crop_params)
      json_response(@crop, :created)
    end

    # PUT /crops/:id
    def update
      @crop.update(crop_params)
      head :no_content
    end

    # DELETE /crops/:id
    def destroy
      @crop.destroy
      head :no_content
    end

    private

    def crop_params
      params.permit(:sow_date,
                    :harvest_date,
                    :container_id,
                    :product_id,
                    :producer_id
      )
    end

    def set_crop
      @crop = Crop.find(params[:id])
    end
  end
end
