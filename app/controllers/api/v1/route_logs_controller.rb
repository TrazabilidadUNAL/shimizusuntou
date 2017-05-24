module Api::V1
  class RouteLogsController < ApplicationController

    before_action :set_route_log, only: [:show, :update, :destroy]

    has_scope :q, only: :index
    has_scope :by_humidity, only: :index
    has_scope :by_temperature, only: :index

    # GET /route_logs
    def index
      @route_logs = RouteLog.where(show: true)
      json_response(@route_logs)
    end

    # GET /route_logs/:id
    def show
      if @route_log
        json_response(@route_log)
      else
        json_response({:message => "Couldn't find RouteLog with id #{params[:id]}"}, :not_found)
      end
    end

    # POST /route_logs
    def create
      @route_log = RouteLog.create!(route_log_params)
      json_response(@route_log, :created)
    end

    # PUT /route_logs/:id
    def update
      @route_log.update(route_log_params)
      head :no_content
    end

    # DELETE /route_logs/:id
    def destroy
      @route_log.show = false
      @route_log.save!
      head :no_content
    end

    private

    def route_log_params
      params.permit(:route_id, :temperature, :humidity, :lat, :lon)
    end

    def set_route_log
      @route_log = RouteLog.find(params[:id])
    end
  end
end
