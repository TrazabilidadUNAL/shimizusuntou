module Api::V1
  class CropsController < ApplicationController
    before_action :set_crop, only: [:show, :update, :destroy]

    # GET /crops
    def index
      json_response(current_user.crops)
    end

    # GET /crops/:id
    def show
      if @crop
        json_response(@crop)
      else
        json_response({:message => "Couldn't find Crop with id #{params[:id]}"}, :not_found)
      end
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
      @crop.show = false
      @crop.save!
      head :no_content
    end

    private

    def crop_params
      params.permit(
          :sow_date,
          :harvest_date,
          :container_id,
          :product_id,
          :producer_id
      )
    end

    def set_crop
      @crop = current_user.crops.find(params[:id])
    end
  end
end
