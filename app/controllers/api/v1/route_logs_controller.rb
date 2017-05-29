module Api::V1
  class RouteLogsController < ApplicationController
    before_action :load_route
    before_action :set_route_log, only: [:show, :update, :destroy]

    has_scope :q, only: :index
    has_scope :by_humidity, only: :index
    has_scope :by_temperature, only: :index

    resource_description do
      desc <<-EOD
      Route logs are key information in a route, they let users get insights about 
      what is happening to their Product's Packages in the transit from an origin to 
      a destination, providing information about temperature, humidity and location 
      via latitude and longitude.
      EOD
    end

    def_param_group :route_log do
      param :temperature, Numeric, 'Temperature registered', required: true
      param :humidity, Numeric, 'Humidity registered', required: true
      param :lat, Numeric, 'Latitude coordinate where the record was sampled', required: true
      param :lon, Numeric, 'Longitude coordinate where the record was sampled', required: true
    end

    api! 'Logs for a given route'
    description 'Shows all the logs for a given route.'
    formats ['json']
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM
    GET /v1/producer/routes/1/route_logs HTTP/1.1
    Accept: */*
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=79fb675bcf535b06c96ad2240e259684
    Connection: keep-alive
    
    
    
    HTTP/1.1 200 OK
    Cache-Control: max-age=0, private, must-revalidate
    Content-Type: application/json; charset=utf-8
    ETag: W/"92f90960a3d3db448844565817c3582f"
    Transfer-Encoding: chunked
    Vary: Origin
    X-Request-Id: dc9b73ff-1bff-4b60-9f3f-66f81bdf5472
    X-Runtime: 0.088176
    
    {
        "data": [
            {
                "created_at": "2017-05-28T02:04:40.759Z", 
                "humidity": 50.0, 
                "id": 1, 
                "lat": 12.12, 
                "lon": 12.12, 
                "route": {
                    "id": 1
                }, 
                "temperature": 25.0
            }, 
            {
                "created_at": "2017-05-28T02:04:46.542Z", 
                "humidity": 50.0, 
                "id": 2, 
                "lat": 12.13, 
                "lon": 12.13, 
                "route": {
                    "id": 1
                }, 
                "temperature": 25.0
            }, 
            {
                "created_at": "2017-05-28T02:04:51.912Z", 
                "humidity": 50.0, 
                "id": 3, 
                "lat": 12.14, 
                "lon": 12.14, 
                "route": {
                    "id": 1
                }, 
                "temperature": 25.0
            }
        ]
    }
    EOM

    def index
      json_response(@route.route_logs)
    end

    api! 'Shows an specific log of a given route'
    description 'Shows a single log for a given route.'
    formats ['json']
    error :code => 404, :desc => "The route log with that id hasn't been found"
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM
    GET /v1/producer/routes/1/route_logs/1 HTTP/1.1
    Accept: */*
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=79fb675bcf535b06c96ad2240e259684
    Connection: keep-alive
    
    
    
    HTTP/1.1 200 OK
    Cache-Control: max-age=0, private, must-revalidate
    Content-Type: application/json; charset=utf-8
    ETag: W/"f2e373640b20c847ca1d8a26d51da017"
    Transfer-Encoding: chunked
    Vary: Origin
    X-Request-Id: 920a3995-d982-4eae-8a1e-09cf36d6eeea
    X-Runtime: 0.351897
    
    {
        "data": {
            "created_at": "2017-05-28T02:04:40.759Z", 
            "humidity": 50.0, 
            "id": 1, 
            "lat": 12.12, 
            "lon": 12.12, 
            "route": {
                "id": 1
            }, 
            "temperature": 25.0
        }
    }
    EOM

    def show
      if @route_log
        json_response(@route_log)
      else
        json_response({:message => "Couldn't find RouteLog with id #{params[:id]}"}, :not_found)
      end
    end

    api! 'Creates a new log for a given route'
    description 'Creates a new log for a give route having its temperature, humidity, latitude and longitude as parameter.'
    param_group :route_log
    formats ['json']
    error :code => 422, :desc => 'Unprocessable entity', :meta => {:problem => 'Missing multiple parameter'}
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM
    POST /v1/producer/routes/1/route_logs HTTP/1.1
    Accept: application/json
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=79fb675bcf535b06c96ad2240e259684
    Connection: keep-alive
    Content-Length: 71
    Content-Type: application/json
    
    {
        "humidity": "60", 
        "lat": "12.15", 
        "lon": "12.15", 
        "temperature": "25"
    }
    
    HTTP/1.1 201 Created
    Cache-Control: max-age=0, private, must-revalidate
    Content-Type: application/json; charset=utf-8
    ETag: W/"89411fb22c645b28a3038a33184026d4"
    Transfer-Encoding: chunked
    Vary: Origin
    X-Request-Id: 9c9a55b7-9556-4a60-869c-58bbb9375064
    X-Runtime: 0.023285
    
    {
        "data": {
            "created_at": "2017-05-29T04:12:42.695Z", 
            "humidity": 60.0, 
            "id": 4, 
            "lat": 12.15, 
            "lon": 12.15, 
            "route": {
                "id": 1
            }, 
            "temperature": 25.0
        }
    }
    EOM

    def create
      json_response(@route.route_logs.create!(route_log_params), :created)
    end

    api! 'Updates an existing log'
    description "Updates an existing log. Useful to correct errors in description. Shouldn't be used."
    param_group :route_log
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM
    PUT /v1/producer/routes/1/route_logs/4 HTTP/1.1
    Accept: application/json
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=79fb675bcf535b06c96ad2240e259684
    Connection: keep-alive
    Content-Length: 18
    Content-Type: application/json
    
    {
        "humidity": "50"
    }
    
    HTTP/1.1 204 No Content
    Cache-Control: no-cache
    Vary: Origin
    X-Request-Id: e07cc959-faf5-44af-b2a4-dd1bcbb82ea9
    X-Runtime: 0.017008
    EOM
    def update
      @route_log.update(route_log_params)
      head :no_content
    end

    api! 'Deletes a log for a given route'
    description 'Deletes a log for a given route using its id.'
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM
    DELETE /v1/producer/routes/1/route_logs/4 HTTP/1.1
    Accept: */*
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=79fb675bcf535b06c96ad2240e259684
    Connection: keep-alive
    Content-Length: 0
    
    
    
    HTTP/1.1 204 No Content
    Cache-Control: no-cache
    Vary: Origin
    X-Request-Id: cc8791cc-d5ed-4aac-9253-1a3cb875bfa6
    X-Runtime: 0.680534
    EOM
    def destroy
      @route_log.destroy
      head :no_content
    end

    private

    def route_log_params
      params.permit(:temperature, :humidity, :lat, :lon)
    end

    def set_route_log
      @route_log = @route.route_logs.find(params[:id])
    end

    def load_route
      @route = Route.find(request.parameters[:route_id])
    end
  end
end
