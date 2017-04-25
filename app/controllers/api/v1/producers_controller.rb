module Api::V1
  class ProducersController < ApplicationController
    before_action :set_producer, only: [:show, :update, :destroy, :products]

    resource_description do
      desc <<-EOD
      Producers are those actors in charge of producing agrifood products.

      The producer must provide authentication keys.
      EOD
    end

    def_param_group :producer do
      param :first_name, String, 'Producer first name', :required => true
      param :last_name, String, 'Producer last name', :required => true
      param :username, String, "Producer account's username", :required => true
      param :password, String, "Producer account's password", :required => true
    end

    api! 'Shows an specific producer'
    description 'Retrieves a single producer in the system'
    formats ['json']
    error :code => 404, :desc => "Producer with that id hasn't been found"
    example <<-EOM
    HTTP/1.1 200 OK
    Cache-Control: max-age=0, private, must-revalidate
    Content-Type: application/json; charset=utf-8
    ETag: W/"5591818e009fcb6fbd9295fc927cd34f"
    Transfer-Encoding: chunked
    Vary: Origin
    X-Content-Type-Options: nosniff
    X-Frame-Options: SAMEORIGIN
    X-Request-Id: c7fbdc7f-e694-4525-bff6-4fd6603efe9d
    X-Runtime: 0.087397
    X-XSS-Protection: 1; mode=block
    
    {
        "data": {
            "first_name": "John", 
            "id": 1, 
            "last_name": "Doe", 
            "username": "jdoe"
        }
    }
    EOM

    def show
      if @producer
        json_response(@producer)
      else
        json_response({:message => "Couldn't find Producer with id #{params[:id]}"}, :not_found)
      end
    end

    api! 'Creates a new producer'
    description 'Creates a new producer having its names, username and password as a parameter.'
    param_group :producer
    error :code => 422, :desc => 'Unprocessable entity', :meta => {:problem => 'Missing multiple parameter'}
    example <<-EOM
    HTTP/1.1 201 Created
    Cache-Control: max-age=0, private, must-revalidate
    Content-Type: application/json; charset=utf-8
    ETag: W/"5591818e009fcb6fbd9295fc927cd34f"
    Transfer-Encoding: chunked
    Vary: Origin
    X-Content-Type-Options: nosniff
    X-Frame-Options: SAMEORIGIN
    X-Request-Id: b072fff7-10ea-4e31-9abd-0c4409ca6a3c
    X-Runtime: 0.285117
    X-XSS-Protection: 1; mode=block
    
    {
        "data": {
            "first_name": "John", 
            "id": 1, 
            "last_name": "Doe", 
            "username": "jdoe"
        }
    }
    EOM

    def create
      @producer = Producer.create!(producer_params)
      json_response(@producer, :created)
    end

    api! 'Updates an existing producer'
    description 'Updates an existing producer'
    param_group :producer
    error :code => 404, :desc => "Producer with that id hasn't been found."
    example <<-EOM
    HTTP/1.1 204 No Content
    Cache-Control: no-cache
    Vary: Origin
    X-Content-Type-Options: nosniff
    X-Frame-Options: SAMEORIGIN
    X-Request-Id: 5088731b-2133-4552-9aeb-bb35edebbcee
    X-Runtime: 0.024239
    X-XSS-Protection: 1; mode=block
    EOM

    def update
      @producer.update(producer_params)
      head :no_content
    end

    api! 'Deletes a producer in the system'
    description 'Deletes a producer in the system given an id.'
    error :code => 404, :desc => "Producer with that id hasn't been found."
    example <<-EOM
    HTTP/1.1 204 No Content
    Cache-Control: no-cache
    Vary: Origin
    X-Content-Type-Options: nosniff
    X-Frame-Options: SAMEORIGIN
    X-Request-Id: 34d373f8-3432-4072-a2ef-38dfd5f93f33
    X-Runtime: 0.054774
    X-XSS-Protection: 1; mode=block
    EOM
    def destroy
      if @producer
        @producer.destroy
        head :no_content
      else
        head :not_found
      end
    end

    private

    def producer_params
      params.permit(:place_id, :first_name, :last_name, :username, :password)
    end

    def set_producer
      @producer = Producer.find(params[:id])
    end
  end
end
