module Api::V1
  class ProducersController < ApplicationController
    before_action :set_producer, only: [:show, :update, :destroy]

    # GET /producers
    def index
      @producers = Producer.where(show: true)
      json_response(@producers)
    end

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
      @producer.show = false
      @producer.save!
      head :no_content
    end

    private

    def producer_params
      params.permit(:place_id, :first_name, :last_name, :username, :password)
    end

    def set_producer
      @producer = Producer.where(show: true).find(params[:id])
    end
  end
end