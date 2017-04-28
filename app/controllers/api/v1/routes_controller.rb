module Api::V1
  class RoutesController < ApplicationController
    before_action :set_route, only: [:show, :update, :destroy]

    # GET /routes
    def index
      @routes = Route.where(show: true)
      if params[:q].present?
        @routes = Route.search(params[:q])
      end
      json_response(@routes)
    end

    # GET /routes/:id
    def show
      if @route
        json_response(@route)
      else
        json_response({:message => "Couldn't find Route with id #{params[:id]}"}, :not_found)
      end
    end

    # POST /routes
    def create
      @route = Route.create!(route_params)
      json_response(@route, :created)
    end

    # PUT /routes/:id
    def update
      @route.update(route_params)
      head :no_content
    end

    # DELETE /routes/:id
    def destroy
      @route.show = false
      @route.save!
      head :no_content
    end

    private

    def route_params
      params.permit(:origin_id, :destination_id)
    end

    def set_route
      @route = Route.find(params[:id])
    end
  end
end
