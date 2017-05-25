module Api::V1
  class TracersController < ApplicationController
    skip_before_action :require_login!, except: []
    before_action :set_pack, only: [:show, :update, :destroy]

    def show
      if @package
        json_response(@package)
      else
        json_response({:message => "Couldn't find a qrhash with id #{params[:qrhash]}"}, :not_found)
      end
    end

    private

    def pack_params
      permitted = params.permit(:qrhash)
    end

    def set_pack
      @package = Package.by_qrhash(params[:qrhash])
    end
  end
end