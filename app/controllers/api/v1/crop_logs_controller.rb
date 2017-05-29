module Api::V1
  class CropLogsController < ApplicationController
    before_action :load_crop
    before_action :set_crop_log, only: [:show, :update, :destroy]

    resource_description do
      desc <<-EOD
      Crop logs are brief descriptions of what is happening to the crop during its
      harvesting time.

      We recommend to be as brief and specific as you can to offer users detailed information
      about what's happening to the products.

      The producer must provide authentication keys.
      EOD
    end

    def_param_group :crop_log do
      param :description, String, "Brief description of what's happening to the product.", required: true
    end

    api! "Logs for a given crop"
    description 'Shows all the logs for a given crop.'
    formats ['json']
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM
    GET /v1/producer/crops/2/crop_logs HTTP/1.1
    Accept: */*
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=79fb675bcf535b06c96ad2240e259684
    Connection: keep-alive
    
    
    
    HTTP/1.1 200 OK
    Cache-Control: max-age=0, private, must-revalidate
    Content-Type: application/json; charset=utf-8
    ETag: W/"aa9a8f710eab6617fa486d3534e5f5e0"
    Transfer-Encoding: chunked
    Vary: Origin
    X-Request-Id: 44d95995-8287-4b41-8061-955a6e8c6f45
    X-Runtime: 0.080308
    
    {
        "data": [
            {
                "created_at": "2017-05-29T01:32:49.255Z", 
                "crop": {
                    "harvest_date": null, 
                    "id": 2, 
                    "sow_date": "2017-05-01T00:00:00.000Z"
                }, 
                "description": "We have sow our tomacco seeds", 
                "id": 3
            }
        ]
    }
    EOM

    def index
      json_response(@crop.crop_logs)
    end

    api! 'Shows an specific log of a given crop'
    description 'Shows a single log for a given crop.'
    formats ['json']
    error :code => 404, :desc => "The crop log with that id hasn't been found"
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM
    GET /v1/producer/crops/2/crop_logs/3 HTTP/1.1
    Accept: */*
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=79fb675bcf535b06c96ad2240e259684
    Connection: keep-alive
    
    
    
    HTTP/1.1 200 OK
    Cache-Control: max-age=0, private, must-revalidate
    Content-Type: application/json; charset=utf-8
    ETag: W/"9a2a06d6e236c423d7a58391b2f41996"
    Transfer-Encoding: chunked
    Vary: Origin
    X-Request-Id: 962ae5ea-8d91-47bf-92a0-31a8743e2d19
    X-Runtime: 0.277365
    
    {
        "data": {
            "created_at": "2017-05-29T01:32:49.255Z", 
            "crop": {
                "harvest_date": null, 
                "id": 2, 
                "sow_date": "2017-05-01T00:00:00.000Z"
            }, 
            "description": "We have sow our tomacco seeds", 
            "id": 3
        }
    }
    EOM

    def show
      if @crop_log
        json_response(@crop_log)
      else
        json_response({:message => "Couldn't find CropLog with id #{params[:id]}"}, :not_found)
      end
    end

    api! 'Creates a new log for a given crop'
    description 'Creates a new log for a give crop having its definition as parameter.'
    param_group :crop_log
    formats ['json']
    error :code => 422, :desc => 'Unprocessable entity', :meta => {:problem => 'Missing multiple parameter'}
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM
    POST /v1/producer/crops/2/crop_logs HTTP/1.1
    Accept: application/json
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=79fb675bcf535b06c96ad2240e259684
    Connection: keep-alive
    Content-Length: 48
    Content-Type: application/json
    
    {
        "description": "We have sow our tomacco seeds"
    }
    
    HTTP/1.1 201 Created
    Cache-Control: max-age=0, private, must-revalidate
    Content-Type: application/json; charset=utf-8
    ETag: W/"9a2a06d6e236c423d7a58391b2f41996"
    Transfer-Encoding: chunked
    Vary: Origin
    X-Request-Id: e8768e0a-7d1b-48a2-8ff6-545dd33d0b84
    X-Runtime: 0.127907
    
    {
        "data": {
            "created_at": "2017-05-29T01:32:49.255Z", 
            "crop": {
                "harvest_date": null, 
                "id": 2, 
                "sow_date": "2017-05-01T00:00:00.000Z"
            }, 
            "description": "We have sow our tomacco seeds", 
            "id": 3
        }
    }
    EOM

    def create
      json_response(@crop.crop_logs.create!(crop_log_params), :created)
    end

    api! 'Updates an existing log'
    description 'Updates an existing log. Useful to correct errors in description'
    param_group :crop_log
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM
    PUT /v1/producer/crops/2/crop_logs/3 HTTP/1.1
    Accept: application/json
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=79fb675bcf535b06c96ad2240e259684
    Connection: keep-alive
    Content-Length: 58
    Content-Type: application/json
    
    {
        "description": "We have sow our addictive tomacco seeds"
    }
    
    HTTP/1.1 204 No Content
    Cache-Control: no-cache
    Vary: Origin
    X-Request-Id: aca8a8b8-cd8c-4242-b00e-4a93111ad9b3
    X-Runtime: 0.171012
    EOM

    def update
      @crop_log.update(crop_log_params)
      head :no_content
    end

    api! 'Deletes a log for a given crop'
    description 'Deletes a log for a given crop using its id.'
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM
    DELETE /v1/producer/crops/2/crop_logs/5 HTTP/1.1
    Accept: */*
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=79fb675bcf535b06c96ad2240e259684
    Connection: keep-alive
    Content-Length: 0
    
    
    
    HTTP/1.1 204 No Content
    Cache-Control: no-cache
    Vary: Origin
    X-Request-Id: df05afb1-3fb5-4d6a-98a9-a86272fcd680
    X-Runtime: 0.031761
    EOM

    def destroy
      @crop_log.destroy
      head :no_content
    end

    private

    def crop_log_params
      params.permit(:description, :crop_id)
    end

    def set_crop_log
      @crop_log = @crop.crop_logs.find(params[:id])
    end

    def load_crop
      @crop = Crop.find(request.parameters[:crop_id])
    end
  end
end
