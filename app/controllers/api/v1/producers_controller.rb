module Api::V1
  class ProducersController < ApplicationController
    skip_before_action :require_login!, only: [:create]

    resource_description do
      desc <<-EOD
      Producers are those actors in charge of producing agrifood products.

      The producer must provide authentication keys.
      EOD
    end

    def_param_group :producer do
      param :first_name, String, 'Producer first name', required: true
      param :last_name, String, 'Producer last name', required: true
      param :username, String, "Producer unique account's username", required: true
      param :password, String, "Producer account's password", required: true
      param :email, String, "Producer's unique email account", required: true
    end

    api! "Current producer's information"
    description 'Shows information for a logged producer.'
    formats ['json']
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM
    GET /v1/producer HTTP/1.1
    Accept: */*
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=9f4eb020e6c43c7363d041f430e913b0
    Connection: keep-alive
    
    
    
    HTTP/1.1 200 OK
    Cache-Control: max-age=0, private, must-revalidate
    Content-Type: application/json; charset=utf-8
    ETag: W/"93f7306739972dedec488f5b07b40d1e"
    Transfer-Encoding: chunked
    Vary: Origin
    X-Request-Id: 2858a419-4bd2-48de-9e85-2d60d856ff5b
    X-Runtime: 0.063114
    
    {
        "data": {
            "email": "amrendonsa@unal.edu.co",
            "first_name": "Mesi",
            "id": 2,
            "last_name": "Rendon",
            "username": "mesirendon"
        }
    }
    EOM

    def show
      json_response(current_user)
    end

    api! 'Creates a new producer'
    description 'Creates a new producer having its first name, last name, email, username and password as parameters.'
    param_group :producer
    error :code => 422, :desc => 'Unprocessable entity', :meta => {:problem => 'Missing multiple parameter'}
    example <<-EOM
    POST /v1/producer HTTP/1.1
    Accept: application/json
    Accept-Encoding: gzip, deflate
    Connection: keep-alive
    Content-Length: 122
    Content-Type: application/json
    
    {
        "email": "jdoe@idk.me",
        "first_name": "John",
        "last_name": "Doe",
        "password": "$uper$ecretPas$$word",
        "username": "jdoe"
    }
    
    HTTP/1.1 201 Created
    Cache-Control: max-age=0, private, must-revalidate
    Content-Type: application/json; charset=utf-8
    ETag: W/"26ebf909a4a442f7a1c760b7b2017921"
    Transfer-Encoding: chunked
    Vary: Origin
    X-Request-Id: 8b0efe03-a293-4af4-b92d-d7983060f729
    X-Runtime: 0.008946
    
    {
        "data": {
            "email": "jdoe@idk.me",
            "first_name": "John",
            "id": 7,
            "last_name": "Doe",
            "username": "jdoe"
        }
    }
    EOM

    def create
      json_response(Producer.create!(producer_params), :created)
    end

    api! 'Updates an existing producer'
    description 'Updates an existing producer'
    param_group :producer
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM
    PUT /v1/producer HTTP/1.1
    Accept: application/json
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=9f4eb020e6c43c7363d041f430e913b0
    Connection: keep-alive
    Content-Length: 24
    Content-Type: application/json
    
    {
        "first_name": "Johnny"
    }
    
    HTTP/1.1 204 No Content
    Cache-Control: no-cache
    Vary: Origin
    X-Request-Id: cf04ddb4-29c5-4d50-8e77-390831677bac
    X-Runtime: 0.247728
    EOM

    def update
      current_user.update(producer_params)
      head :no_content
    end

    api! 'Deletes a producer in the system'
    description 'Deletes a producer in the system given an id.'
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM
    DELETE /v1/producer HTTP/1.1
    Accept: */*
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=9f4eb020e6c43c7363d041f430e913b0
    Connection: keep-alive
    Content-Length: 0
    
    
    
    HTTP/1.1 204 No Content
    Cache-Control: no-cache
    Vary: Origin
    X-Request-Id: 2d868cc9-aad8-4442-89b8-61a0a589ed15
    X-Runtime: 0.278083
    EOM

    def destroy
      current_user.destroy
      head :no_content
    end

    private

    def producer_params
      params.permit(:place_id, :first_name, :last_name, :username, :password, :email)
    end
  end
end
