module Api::V1
  class CropLogsController < ApplicationController
    before_action :set_crop_log, only: [:show, :update, :destroy]

    # GET /crops
    def index
      @crop_logs = CropLog.where(show: true)
      if params[:sort].present?
        @crop_logs = CropLog.search(params[:q],params[:sort])
      elsif params[:q].present?
        @crop_logs = CropLog.search(params[:q])
      end
      json_response(@crop_logs)
    end

    # GET /crops/:id
    def show
      if @crop_log
        json_response(@crop_log)
      else
        json_response({:message => "Couldn't find CropLog with id #{params[:id]}"}, :not_found)
      end
    end

    # POST /crops
    def create
      @crop_log = CropLog.create!(crop_log_params)
      json_response(@crop_log, :created)
    end

    # PUT /crops/:id
    def update
      @crop_log.update(crop_log_params)
      head :no_content
    end

    # DELETE /crops/:id
    def destroy
      @crop_log.show = false
      @crop_log.save!
      head :no_content
    end

    private

    def crop_log_params
      params.permit(:description, :crop_id)
    end

    def set_crop_log
      @crop_log = CropLog.find(params[:id])
    end
  end
end
