module Api::V1
  class PlacesController < ApplicationController
    before_action :set_place, only: [:show, :update, :destroy]

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

    api! "Shows all user's places"
    description 'Retrieves the whole list of places in the system for a specific user. If there are not enough records an empty array is returned.'
    formats ['json']
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM
    GET /v1/producer/places HTTP/1.1
    Accept: */*
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=60c0aefdd4324b5a92c5f7ea83e757df
    Connection: keep-alive
    
    
    
    HTTP/1.1 200 OK
    Cache-Control: max-age=0, private, must-revalidate
    Content-Type: application/json; charset=utf-8
    ETag: W/"513eda4ae3df825faa50c4e676954457"
    Transfer-Encoding: chunked
    Vary: Origin
    X-Request-Id: 105562c0-ef66-4371-ab26-1f30e8bdd3b9
    X-Runtime: 0.011457
    
    {
        "data": [
            {
                "id": 2,
                "lat": 12.12,
                "lon": 12.12,
                "tag": "My Farm"
            },
            {
                "id": 3,
                "lat": 13.13,
                "lon": 13.13,
                "tag": "My Other Farm"
            }
        ]
    }
    EOM

    def index
      @places = current_user.places
      json_response(@places)
    end

    api! 'Shows an specific place'
    description 'Retrieves a single place in the system'
    formats ['json']
    error :code => 404, :desc => "Place with that id hasn't been found"
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM
    GET /v1/producer/places/2 HTTP/1.1
    Accept: */*
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=60c0aefdd4324b5a92c5f7ea83e757df
    Connection: keep-alive
    
    
    
    HTTP/1.1 200 OK
    Cache-Control: max-age=0, private, must-revalidate
    Content-Type: application/json; charset=utf-8
    ETag: W/"c52b6fc3ebe1457ff08c0d027c1a46a3"
    Transfer-Encoding: chunked
    Vary: Origin
    X-Request-Id: 34f165fd-60f0-4a1b-b789-1e3b90dfb4e1
    X-Runtime: 0.079694
    
    {
        "data": {
            "id": 2,
            "lat": 12.12,
            "lon": 12.12,
            "tag": "My Farm"
        }
    }
    EOM

    def show
      if @place
        json_response(@place)
      else
        json_response({:message => "Couldn't find a Place with id #{params[:id]}"}, :not_found)
      end
    end

    api! 'Creates a new place for a logged user'
    description 'Creates a new place having its tag, latitude and longitude as parameters.'
    formats ['json']
    param_group :place
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM
    POST /v1/producer/places HTTP/1.1
    Accept: application/json
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=60c0aefdd4324b5a92c5f7ea83e757df
    Connection: keep-alive
    Content-Length: 50
    Content-Type: application/json
    
    {
        "lat": "12.12",
        "lon": "12.12",
        "tag": "My Farm"
    }
    
    HTTP/1.1 201 Created
    Cache-Control: max-age=0, private, must-revalidate
    Content-Type: application/json; charset=utf-8
    ETag: W/"c52b6fc3ebe1457ff08c0d027c1a46a3"
    Transfer-Encoding: chunked
    Vary: Origin
    X-Request-Id: 39719c53-eb91-431c-9514-f26b09e2b4eb
    X-Runtime: 0.013140
    
    {
        "data": {
            "id": 2,
            "lat": 12.12,
            "lon": 12.12,
            "tag": "My Farm"
        }
    }
    EOM

    def create
      @place = Place.new(place_params)
      @place.localizable = current_user
      @place.save!
      json_response(@place, :created)
    end

    api! 'Updates an existing place'
    description 'Updates an existing place.'
    formats ['json']
    param_group :place
    error :code => 404, :desc => "Place with that id hasn't been found"
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM
    PUT /v1/producer/places/2 HTTP/1.1
    Accept: application/json
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=60c0aefdd4324b5a92c5f7ea83e757df
    Connection: keep-alive
    Content-Length: 55
    Content-Type: application/json
    
    {
        "lat": "23.23",
        "lon": "23.23",
        "tag": "My Mega Farm"
    }
    
    HTTP/1.1 204 No Content
    Cache-Control: no-cache
    Vary: Origin
    X-Request-Id: 453e909c-9dfd-4934-8e70-b98d5a95a425
    X-Runtime: 0.028701
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
    description 'Deletes a place in the system given its id.'
    formats ['json']
    error :code => 404, :desc => "Place with that id hasn't been found."
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM
    DELETE /v1/producer/places/3 HTTP/1.1
    Accept: */*
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=60c0aefdd4324b5a92c5f7ea83e757df
    Connection: keep-alive
    Content-Length: 0
    
    
    
    HTTP/1.1 204 No Content
    Cache-Control: no-cache
    Vary: Origin
    X-Request-Id: c5dd7203-527e-4933-ac6e-82ff65e2f051
    X-Runtime: 0.036598
    EOM
    def destroy
      if @place
        @place.destroy
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
      @place = current_user.places.find(params[:id])
    end
  end
end
