module Api::V1
  class RoutesController < ApplicationController
    before_action :set_route, only: [:show, :update, :destroy]

    has_scope :q, only: :index

    resource_description do
      desc <<-EOD
      Routes are the connections between Producers and Warehouses, or even between Warehouses themselves.
      
      A route let us know how two Places are connected. It also shows a series of logs 
      that let users know under what conditions (i.e. Temperature, Humidity and 
      Location via Latitude and Longitude) a Package was transported.
      EOD
    end

    def_param_group :route do
      param :origin_id, Integer, "Origin place id", :required => true
      param :destination_id, Integer, "Destination place id", :required => true
    end

    api! 'Shows all routes for a given user'
    description 'Shows all the routes for a given user, no matter if they are origins or destinations.'
    formats ['json']
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM
    GET /v1/producer/routes HTTP/1.1
    Accept: */*
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=79fb675bcf535b06c96ad2240e259684
    Connection: keep-alive
    
    
    
    HTTP/1.1 200 OK
    Cache-Control: max-age=0, private, must-revalidate
    Content-Type: application/json; charset=utf-8
    ETag: W/"6ce78f47864a918f6065389e85b5710f"
    Transfer-Encoding: chunked
    Vary: Origin
    X-Request-Id: d0a8226b-a843-41f7-b548-b1893ba07255
    X-Runtime: 1.009270
    
    {
        "data": [
            {
                "destination": {
                    "id": 4, 
                    "lat": 12.21, 
                    "lon": 12.21, 
                    "tag": "My Great Store"
                }, 
                "id": 1, 
                "origin": {
                    "id": 2, 
                    "lat": 23.23, 
                    "lon": 23.23, 
                    "tag": "My Mega Farm"
                }, 
                "route_logs": [
                    {
                        "created_at": "2017-05-28T02:04:40.759Z", 
                        "humidity": 50.0, 
                        "id": 1, 
                        "lat": 12.12, 
                        "lon": 12.12, 
                        "temperature": 25.0
                    }, 
                    {
                        "created_at": "2017-05-28T02:04:46.542Z", 
                        "humidity": 50.0, 
                        "id": 2, 
                        "lat": 12.13, 
                        "lon": 12.13, 
                        "temperature": 25.0
                    }, 
                    {
                        "created_at": "2017-05-28T02:04:51.912Z", 
                        "humidity": 50.0, 
                        "id": 3, 
                        "lat": 12.14, 
                        "lon": 12.14, 
                        "temperature": 25.0
                    }
                ]
            }
        ]
    }
    EOM
    def index
      @routes = apply_scopes(current_user.routes).order(ordering_params(params)).all
      json_response(@routes)
    end

    api! 'Shows an specific route given its id'
    description 'Retrieves a single route for a given user using its id.'
    formats ['json']
    error :code => 404, :desc => "Route with that id hasn't been found"
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM
    GET /v1/producer/routes/1 HTTP/1.1
    Accept: */*
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=79fb675bcf535b06c96ad2240e259684
    Connection: keep-alive
    
    
    
    HTTP/1.1 200 OK
    Cache-Control: max-age=0, private, must-revalidate
    Content-Type: application/json; charset=utf-8
    ETag: W/"3a98a8daada9d5a947335463d92bd20e"
    Transfer-Encoding: chunked
    Vary: Origin
    X-Request-Id: fa2153d3-a889-48e1-8432-8054e40c8ff4
    X-Runtime: 0.295023
    
    {
        "data": {
            "destination": {
                "id": 4, 
                "lat": 12.21, 
                "lon": 12.21, 
                "tag": "My Great Store"
            }, 
            "id": 1, 
            "origin": {
                "id": 2, 
                "lat": 23.23, 
                "lon": 23.23, 
                "tag": "My Mega Farm"
            }, 
            "route_logs": [
                {
                    "created_at": "2017-05-28T02:04:40.759Z", 
                    "humidity": 50.0, 
                    "id": 1, 
                    "lat": 12.12, 
                    "lon": 12.12, 
                    "temperature": 25.0
                }, 
                {
                    "created_at": "2017-05-28T02:04:46.542Z", 
                    "humidity": 50.0, 
                    "id": 2, 
                    "lat": 12.13, 
                    "lon": 12.13, 
                    "temperature": 25.0
                }, 
                {
                    "created_at": "2017-05-28T02:04:51.912Z", 
                    "humidity": 50.0, 
                    "id": 3, 
                    "lat": 12.14, 
                    "lon": 12.14, 
                    "temperature": 25.0
                }
            ]
        }
    }
    EOM
    def show
      if @route
        json_response(@route)
      else
        json_response({:message => "Couldn't find Route with id #{params[:id]}"}, :not_found)
      end
    end

    api! 'Creates a new route'
    description 'Creates a new route having its origin and destination ids as parameters.'
    param_group :route
    error :code => 422, :desc => 'Unprocessable entity', :meta => {:problem => 'Missing multiple parameter'}
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM
    POST /v1/producer/routes HTTP/1.1
    Accept: application/json
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=79fb675bcf535b06c96ad2240e259684
    Connection: keep-alive
    Content-Length: 41
    Content-Type: application/json
    
    {
        "destination_id": "3", 
        "origin_id": "5"
    }
    
    HTTP/1.1 201 Created
    Cache-Control: max-age=0, private, must-revalidate
    Content-Type: application/json; charset=utf-8
    ETag: W/"1ccdaeb878cd9ae36b9f1f9607837de6"
    Transfer-Encoding: chunked
    Vary: Origin
    X-Request-Id: 04805285-5259-40b1-83fe-89925ecd9185
    X-Runtime: 0.256457
    
    {
        "data": {
            "destination": {
                "id": 3, 
                "lat": 13.13, 
                "lon": 13.13, 
                "tag": "My Other Farm"
            }, 
            "id": 2, 
            "origin": {
                "id": 5, 
                "lat": 32.32, 
                "lon": 43.12, 
                "tag": "My second big farm"
            }, 
            "route_logs": []
        }
    }
    EOM
    def create
      json_response(Route.create!(route_params), :created)
    end

    api! 'Updates an existing route'
    description 'Updates an existing route'
    param_group :route
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM
    PUT /v1/producer/routes/3 HTTP/1.1
    Accept: application/json
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=79fb675bcf535b06c96ad2240e259684
    Connection: keep-alive
    Content-Length: 23
    Content-Type: application/json
    
    {
        "destination_id": "2"
    }
    
    HTTP/1.1 204 No Content
    Cache-Control: no-cache
    Vary: Origin
    X-Request-Id: ebc68c9d-017d-40f3-8e48-adb056c1734f
    X-Runtime: 0.029641
    EOM
    def update
      @route.update(route_params)
      head :no_content
    end

    api! 'Deletes a route in the system'
    description 'Deletes a route in the system given an id.'
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM
    DELETE /v1/producer/routes/3 HTTP/1.1
    Accept: */*
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=79fb675bcf535b06c96ad2240e259684
    Connection: keep-alive
    Content-Length: 0
    
    
    
    HTTP/1.1 204 No Content
    Cache-Control: no-cache
    Vary: Origin
    X-Request-Id: 78a471f5-1ab2-4f79-ad50-7bf31bb3e947
    X-Runtime: 0.033816
    EOM
    def destroy
      @route.destroy
      head :no_content
    end

    private

    def route_params
      params.permit(:origin_id, :destination_id)
    end

    def set_route
      @route = current_user.routes.find(params[:id])
    end

  end
end
