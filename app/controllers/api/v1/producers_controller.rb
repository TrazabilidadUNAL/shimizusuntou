module Api::V1
  class ProducersController < ApplicationController
    before_action :set_producer, only: [:show, :update, :destroy]

    # GET /producers/:id
    def show
      json_response(@producer)
    end

    # POST /producers
    def create
      @producer = Producer.create!(producer_params)
      json_response(@producer, :created)
    end

    # PUT /producers/:id
    def update
      @producer.update(producer_params)
      head :no_content
    end

    # DELETE /producers/:id
    def destroy
      @producer.destroy
      head :no_content
    end

    private

    def producer_params
      params.permit(:place_id, :first_name, :last_name, :username, :password)
    end

    def set_producer
      @producer = Producer.by_id(params[:id])
      # @producer = Producer.find(params[:id])
    end
  end
end
