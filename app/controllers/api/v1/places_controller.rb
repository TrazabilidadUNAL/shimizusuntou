module Api::V1
  class PlacesController < ApplicationController
    before_action :set_place, only: [:show, :update, :destroy]

    # GET /places
    def index
      @places = Place.where(show: true)
      json_response(@places)
    end

    # GET /places/:id
    def show
      json_response(@place)
    end

    # POST /places
    def create
      @place = Place.create!(place_params)
      json_response(@place, :created)
    end

    # PUT /places/:id
    def update
      @place.update(place_params)
      head :no_content
    end

    # DELETE /places/:id
    def destroy
      @place.show = false
      @place.save!
      head :no_content
    end

    private

    def place_params
      params.permit(:tag, :lat, :lon)
    end

    def set_place
      @place = Place.where(show: true).find(params[:id])
    end
  end
end
