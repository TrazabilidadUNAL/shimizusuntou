module Api::V1
  class WarehousesController < ApplicationController
    skip_before_action :require_login!, only: [:create]

    resource_description do
      desc <<-EOD
      Warehouses are those actors in charge of stowe agrifood products.
      This is an abstraction of an actual Warehouse, or a retailer, distributor and seller.

      The warehouse must provide authentication keys
      EOD
    end

    def_param_group :warehouse do
      param :name, String, 'Warehouse name', required: true
      param :username, String, "Producer unique account's username", required: true
      param :password, String, "Producer account's password", required: true
      param :email, String, "Producer's unique email account", required: true
    end

    api! "Current warehouse's information"
    description 'Shows information for a logged warehouse'
    formats ['json']
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM
    GET /v1/warehouse HTTP/1.1
    Accept: */*
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=53940a26762211abf6895a92376005b2
    Connection: keep-alive
    
    
    
    HTTP/1.1 200 OK
    Cache-Control: max-age=0, private, must-revalidate
    Content-Type: application/json; charset=utf-8
    ETag: W/"07d9e35594742cc80c8df0a3ce3c0578"
    Transfer-Encoding: chunked
    Vary: Origin
    X-Request-Id: 3001c228-fc05-481f-b8f9-dc6dbd02a4ea
    X-Runtime: 0.232402
    
    {
        "data": {
            "email": "meg@stor.es",
            "id": 3,
            "name": "Mega Retailer",
            "username": "megastores"
        }
    }
    EOM
    def show
      json_response(current_user)
    end

    api! 'Creates a new warehouse'
    description 'Creates a new warehouse having its name, email, username and password as parameters.'
    param_group :warehouse
    error :code => 422, :desc => 'Unprocessable entity', :meta => {:problem => 'Missing multiple parameter'}
    example <<-EOM
    POST /v1/warehouse HTTP/1.1
    Accept: application/json
    Accept-Encoding: gzip, deflate
    Connection: keep-alive
    Content-Length: 110
    Content-Type: application/json
    
    {
        "email": "meg@stor.es",
        "name": "Mega Retailer",
        "password": "$uper$ecretPa$$word",
        "username": "megastores"
    }
    
    HTTP/1.1 201 Created
    Cache-Control: max-age=0, private, must-revalidate
    Content-Type: application/json; charset=utf-8
    ETag: W/"07d9e35594742cc80c8df0a3ce3c0578"
    Transfer-Encoding: chunked
    Vary: Origin
    X-Request-Id: 32073652-c073-4bb4-9ec1-402e44ac474c
    X-Runtime: 0.011459
    
    {
        "data": {
            "email": "meg@stor.es",
            "id": 3,
            "name": "Mega Retailer",
            "username": "megastores"
        }
    }
    EOM

    def create
      json_response(Warehouse.create!(warehouse_params), :created)
    end

    api! 'Updates an existing warehouse'
    description 'Updates an existing warehouse'
    param_group :warehouse
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM
    PUT /v1/warehouse HTTP/1.1
    Accept: application/json
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=53940a26762211abf6895a92376005b2
    Connection: keep-alive
    Content-Length: 23
    Content-Type: application/json
    
    {
        "name": "Mega Stores"
    }
    
    HTTP/1.1 204 No Content
    Cache-Control: no-cache
    Vary: Origin
    X-Request-Id: aac5981c-c240-4cfb-a11e-ac5d67e4d89d
    X-Runtime: 0.180864
    EOM
    def update
      current_user.update(warehouse_params)
      head :no_content
    end

    api! 'Deletes a warehouse in the system'
    description 'Deletes a warehouse in the system given an id.'
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM
    DELETE /v1/warehouse HTTP/1.1
    Accept: */*
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=be3e51a8464537620eb35d077eaa44d9
    Connection: keep-alive
    Content-Length: 0
    
    
    
    HTTP/1.1 204 No Content
    Cache-Control: no-cache
    Vary: Origin
    X-Request-Id: fb73c56a-72e7-419b-9551-f9e22465ccbd
    X-Runtime: 0.033287

    EOM
    def destroy
      current_user.destroy
      head :no_content
    end

    private

    def warehouse_params
      params.permit(:place_id, :name, :username, :password, :email)
    end
  end
end
