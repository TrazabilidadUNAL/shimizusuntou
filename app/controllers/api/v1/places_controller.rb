module Api::V1
  class PlacesController < ApplicationController
    before_action :set_place, only: [:show, :update, :destroy]
    before_action :load_localizable

    # GET /places
    def index
      @places = Place.where(show: true, localizable_id: @localizable.id, localizable_type: @localizable.class.name)
      json_response(@places)
    end

    # GET /places/:id
    def show
      json_response(@place)
    end

    # POST /places
    def create
      @place = Place.new(place_params)
      @place.localizable = @localizable
      @place.save!
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

    def load_localizable
      parent, id = request.path.split('/')[2,2]
      @localizable = parent.singularize.classify.constantize.find(id)
    end
  end
end
