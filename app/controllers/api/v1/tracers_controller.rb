module Api::V1
  class TracersController < ApplicationController
    skip_before_action :require_login!, except: []
    before_action :set_tracer, only: [:show]

    def show
      if @tracer
        json_response(@tracer, :ok, [
            'route',
            'route.origin',
            'route.destination',
            'route.route_logs',
            'product',
            'container',
            'crop',
            'crop.crop_logs'
        ])
      else
        json_response({:message => "Couldn't find a qrhash with id #{params[:qrhash]}"}, :not_found)
      end
    end

    private

    def set_tracer
      @tracer = Tracer.by_qrhash(params[:qrhash])
    end
  end
end