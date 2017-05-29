module Api::V1
  class ContainersController < ApplicationController
    before_action :set_container, only: [:show, :update, :destroy]

    resource_description do
      desc <<-EOD
      Containers available in the system.

      These Containers are essential to set a Crop.

      The Containers also relates to the Producers and Warehouses and can give an statistic of what and how they are dealing with them.

      Currently containers are only created and edited by admin staff.
      EOD
    end

    def_param_group :container do
      param :name, String, "Container's name", :required => true
    end

    api! 'Shows all containers'
    description 'General: Shows all the containers available in the system. For users: Shows all the containers for a certain user.'
    formats ['json']
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM

    EOM

    def index
      if direct?
        @containers = apply_scopes(Container).order(ordering_params(params)).all
      else
        @containers = apply_scopes(current_user.containers).order(ordering_params(params)).all
      end
      json_response(@containers)
    end

    api! 'Shows an specific container'
    description 'Retrieves a single container in the system.'
    formats ['json']
    error :code => 404, :desc => "Container with that id hasn't been found"
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM
    GET /v1/containers HTTP/1.1
    Accept: */*
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=79fb675bcf535b06c96ad2240e259684
    Connection: keep-alive
    
    
    
    HTTP/1.1 200 OK
    Cache-Control: max-age=0, private, must-revalidate
    Content-Type: application/json; charset=utf-8
    ETag: W/"872f7136ae22b69bcd0ff3a284d327cb"
    Transfer-Encoding: chunked
    Vary: Origin
    X-Request-Id: 87416d28-a002-4971-9c10-9946da228bfe
    X-Runtime: 0.096118
    
    {
        "data": [
            {
                "id": 1, 
                "name": "Bulto"
            }
        ]
    }
    EOM

    def show
      if @container
        json_response(@container)
      else
        json_response({:message => "Couldn't find Container with id #{params[:id]}"}, :not_found)
      end
    end

    def create
      json_response(Container.create!(container_params), :created)
    end

    def update
      if @container
        @container.update(container_params)
        head :no_content
      else
        head :not_found
      end
    end

    def destroy
      if @container
        @container.destroy
        head :no_content
      else
        head :not_found
      end
    end

    private

    def container_params
      params.permit(:name)
    end

    def set_container
      if direct?
        @container = Container.find(params[:id])
      else
        @container = current_user.crops.find(params[:id])
      end
    end

    def direct?
      if request.fullpath.split('/')[2] == 'containers'
        return true
      end
      false
    end
  end
end
