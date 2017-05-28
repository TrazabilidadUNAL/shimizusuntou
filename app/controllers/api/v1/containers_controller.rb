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

    # GET /containers/:id
    def show
      if @container
        json_response(@container)
      else
        json_response({:message => "Couldn't find Container with id #{params[:id]}"}, :not_found)
      end
    end

    # POST /containers
    def create
      @container = Container.create!(container_params)
      json_response(@container, :created)
    end

    # PUT /containers/:id
    def update
      @container.update(container_params)
      head :no_content
    end

    # DELETE /containers/:id
    def destroy
      @container.show = false
      @container.save!
      head :no_content
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
