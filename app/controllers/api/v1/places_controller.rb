module Api::V1
  class PlacesController < ApplicationController
    before_action :set_place, only: [:show, :update, :destroy]
    before_action :load_localizable

    resource_description do
      description <<-EOD
      Places are nested resources for producers and warehouses. They are shown upon their users.
      EOD
    end

    def_param_group :place do
      param :tag, String, 'Place tag identification', :required => true
      param :lat, Float, 'Place location lat', :required => true
      param :lon, Float, 'Place location lon', :required => true
    end

    api! "Shows all onwer's places"
    description 'Retrieves the whole list of places in the system for a specific owner. If there are not enough records an empty array is returned.'
    formats ['json']
    example <<-EOM
    HTTP/1.1 200 OK
    Cache-Control: max-age=0, private, must-revalidate
    Content-Type: application/json; charset=utf-8
    ETag: W/"7f9f6a7e2fd07cf7d23b8d32d7885ef8"
    Transfer-Encoding: chunked
    Vary: Origin
    X-Content-Type-Options: nosniff
    X-Frame-Options: SAMEORIGIN
    X-Request-Id: 5729aa89-b3d0-4033-9a54-3c5db3771633
    X-Runtime: 0.187145
    X-XSS-Protection: 1; mode=block
    
    {
        "data": [
            {
                "id": 1002, 
                "lat": -34.34, 
                "lon": 23.43, 
                "tag": "Fancy Farm"
            }, 
            {
                "id": 1, 
                "lat": 20.9939279706483, 
                "lon": -69.5224926587542, 
                "tag": "Kshlerin Village"
            }
        ]
    }
    EOM

    def index
      @places = Place.where(show: true, localizable_id: @localizable.id, localizable_type: @localizable.class.name)
      json_response(@places)
    end

    api! 'Shows an specific place'
    description 'Retrieves a single place in the system'
    formats ['json']
    error :code => 404, :desc => "Place with that id hasn't been found"
    example <<-EOM
    HTTP/1.1 200 OK
    Cache-Control: max-age=0, private, must-revalidate
    Content-Type: application/json; charset=utf-8
    ETag: W/"510e3c39baab95d1b5472529d5481ded"
    Transfer-Encoding: chunked
    Vary: Origin
    X-Content-Type-Options: nosniff
    X-Frame-Options: SAMEORIGIN
    X-Request-Id: 0b8310d1-c4bb-4680-bc0a-af974f9d6bf0
    X-Runtime: 0.046516
    X-XSS-Protection: 1; mode=block
    
    {
        "data": {
            "id": 1, 
            "lat": 20.9939279706483, 
            "lon": -69.5224926587542, 
            "tag": "Kshlerin Village"
        }
    }
    EOM

    def show
      if @place
        json_response(@place)
      else
        json_response({:message => "Couldn't find a place with id #{params[:id]}"}, :not_found)
      end
    end

    api! 'Creates a new place'
    description 'Creates a new place having its name as a parameter.'
    param_group :place
    error :code => 422, :desc => 'Unprocessable entity', :meta => {:problem => 'Missing multiple parameter'}
    example <<-EOM
    HTTP/1.1 201 Created
    Cache-Control: max-age=0, private, must-revalidate
    Content-Type: application/json; charset=utf-8
    ETag: W/"142643d3baeffee61ccd7c610181fe97"
    Transfer-Encoding: chunked
    Vary: Origin
    X-Content-Type-Options: nosniff
    X-Frame-Options: SAMEORIGIN
    X-Request-Id: b5cb167b-160b-48f0-adcb-ac2b4c9aa186
    X-Runtime: 0.024305
    X-XSS-Protection: 1; mode=block
    
    {
        "data": {
            "id": 1002, 
            "lat": -34.34, 
            "lon": 23.43, 
            "tag": "Fancy Farm"
        }
    }
    EOM

    def create
      @place = Place.new(place_params)
      @place.localizable = @localizable
      @place.save!
      json_response(@place, :created)
    end

    api! 'Updates an existing place'
    description 'Updates an existing place.'
    param_group :place
    error :code => 404, :desc => "Place with that id hasn't been found"
    example <<-EOM
    HTTP/1.1 204 No Content
    Cache-Control: no-cache
    Vary: Origin
    X-Content-Type-Options: nosniff
    X-Frame-Options: SAMEORIGIN
    X-Request-Id: dc793f32-5c84-4e30-b689-dff69e0baf75
    X-Runtime: 0.041470
    X-XSS-Protection: 1; mode=block
    EOM

    def update
      if @place
        @place.update(place_params)
        head :no_content
      else
        head :not_found
      end
    end

    api! 'Deletes a place in the system'
    description 'Deletes a place in the system given an id.'
    error :code => 404, :desc => "Place with that id hasn't been found."
    example <<-EOM
    HTTP/1.1 204 No Content
    Cache-Control: no-cache
    Vary: Origin
    X-Content-Type-Options: nosniff
    X-Frame-Options: SAMEORIGIN
    X-Request-Id: 841effba-dbac-4dae-a52c-312d5cdc4d5f
    X-Runtime: 0.021002
    X-XSS-Protection: 1; mode=block
    EOM
    def destroy
      if @place
        @place.show = false
        @place.save!
        head :no_content
      else
        head :not_found
      end
    end

    private

    def place_params
      params.permit(:tag, :lat, :lon)
    end

    def set_place
      @place = Place.exists?(params[:id]) ? Place.where(show: true).find(params[:id]) : nil
    end

    def load_localizable
      parent, id = request.path.split('/')[2, 2]
      @localizable = parent.singularize.classify.constantize.find(id)
    end
  end
end
