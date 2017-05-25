module Api::V1
  class RoutesController < ApplicationController
    skip_before_action :require_login!, except: []
    before_action :set_route, only: [:show, :update, :destroy]
    before_action :load_parent

    has_scope :q, only: :index

    # GET /routes
    def index
      if @parentable && require_login!
        @routes = apply_scopes(@parentable.routes).order(ordering_params(params)).all
      else
        @routes = apply_scopes(Route).order(ordering_params(params)).all
      end
      json_response(@routes)
    end

    # GET /routes/:id
    def show
      if @route
        json_response(@route)
      else
        json_response({:message => "Couldn't find Route with id #{params[:id]}"}, :not_found)
      end
    end

    # POST /routes
    def create
      @route = Route.create!(route_params)
      json_response(@route, :created)
    end

    # PUT /routes/:id
    def update
      @route.update(route_params)
      head :no_content
    end

    # DELETE /routes/:id
    def destroy
      @route.show = false
      @route.save!
      head :no_content
    end

    private

    def route_params
      params.permit(:origin_id, :destination_id)
    end

    def set_route
      @route = Route.find(params[:id])
    end

    def load_parent
      if request.path.split('/')[2] != 'routes'
        parent, id = request.path.split('/')[2, 2]
        @parentable = parent.singularize.classify.constantize.find(id)
      end
    end

  end
end
