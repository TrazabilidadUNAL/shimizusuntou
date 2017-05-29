module Api::V1
  class CropsController < ApplicationController
    before_action :set_crop, only: [:show, :update, :destroy]

    resource_description do
      desc <<-EOD
      Crops are the main activity of Producers. They log as much as they can in the CropLog.
      Through Crops, you can know about the Product and the Container and you can as detailed as you want.

      Crops are resources only in the domain of Producers.
      EOD
    end

    def_param_group :crop do
      param :sow_date, DateTime, "Crop's sow date", required: true
      param :harvest_date, DateTime, "Crop's harvest date"
      param :container_id, Integer, "Container's id that is intended to be used for packing"
      param :product_id, Integer, "Product's id that is being planned to be sow"
    end

    api! "Current producer's crops"
    description 'Shows all the crops for a logged producer.'
    formats ['json']
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM
    GET /v1/producer/crops HTTP/1.1
    Accept: */*
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=79fb675bcf535b06c96ad2240e259684
    Connection: keep-alive
    
    
    
    HTTP/1.1 200 OK
    Cache-Control: max-age=0, private, must-revalidate
    Content-Type: application/json; charset=utf-8
    ETag: W/"146e82715e71a71306c31126dbfad721"
    Transfer-Encoding: chunked
    Vary: Origin
    X-Request-Id: 393ea27e-e00d-4723-a570-b43f68de4473
    X-Runtime: 0.263764
    
    {
        "data": [
            {
                "container": {
                    "id": 1, 
                    "name": "Bulto"
                }, 
                "crop_logs": [
                    {
                        "created_at": "2017-05-28T02:03:19.676Z", 
                        "description": "Acabo de cosechar", 
                        "id": 2
                    }, 
                    {
                        "created_at": "2017-05-28T02:02:59.110Z", 
                        "description": "Acabo de sembrar", 
                        "id": 1
                    }
                ], 
                "harvest_date": "2017-05-28T01:49:41.689Z", 
                "id": 1, 
                "product": {
                    "description": "Tomacco was originally a fictional plant that was a hybrid between tomatoes and tobacco, from a 1999 episode of The Simpsons titled 'E-I-E-I-(Annoyed Grunt)'. The method used to create the tomacco in the episode is fictional. In the episode, the tomacco was accidentally created by Homer Simpson when he planted and fertilized his tomato and tobacco fields with plutonium. The result is a tomato that apparently has a dried, brown tobacco center, and, although being described as tasting terrible by many characters, is also immediately and powerfully addictive. The creation is promptly labeled 'tomacco' by Homer and sold in large quantities to unsuspecting passersby. A cigarette company, Laramie Tobacco Co., seeing the opportunity to legally sell their products to children, offers to buy the rights to market tomacco, but Homer demands one thousand times as much money as they wish to pay him, and the company withdraws. Eventually, all of the tomacco plants are eaten by farm animals — except for the one remaining plant, which later goes down in an explosive helicopter crash with the cigarette company's lawyers. - From https://en.wikipedia.org/wiki/Products_produced_from_The_Simpsons#Tomacco", 
                    "id": 1, 
                    "image_url": "http://2.media.bustedtees.cvcdn.com/c/-/bustedtees.f878919c-e3ae-4eba-b8e3-52b300cb.gif", 
                    "name": "Tomacco"
                }, 
                "sow_date": "2017-05-28T01:48:06.000Z"
            }
        ]
    }
    EOM

    def index
      json_response(current_user.crops)
    end

    api! "Current producer's crop"
    description "Shows information for logged producer's specific crop."
    formats ['json']
    error :code => 404, :desc => "Crop with that id hasn't been found"
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM
    GET /v1/producer/crops/1 HTTP/1.1
    Accept: */*
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=79fb675bcf535b06c96ad2240e259684
    Connection: keep-alive
    
    
    
    HTTP/1.1 200 OK
    Cache-Control: max-age=0, private, must-revalidate
    Content-Type: application/json; charset=utf-8
    ETag: W/"1dcbd6c01ab97473fcff1470527d707a"
    Transfer-Encoding: chunked
    Vary: Origin
    X-Request-Id: 201771ad-f444-4a7b-9011-3bbb54e992f0
    X-Runtime: 0.117330
    
    {
        "data": {
            "container": {
                "id": 1, 
                "name": "Bulto"
            }, 
            "crop_logs": [
                {
                    "created_at": "2017-05-28T02:03:19.676Z", 
                    "description": "Acabo de cosechar", 
                    "id": 2
                }, 
                {
                    "created_at": "2017-05-28T02:02:59.110Z", 
                    "description": "Acabo de sembrar", 
                    "id": 1
                }
            ], 
            "harvest_date": "2017-05-28T01:49:41.689Z", 
            "id": 1, 
            "product": {
                "description": "Tomacco was originally a fictional plant that was a hybrid between tomatoes and tobacco, from a 1999 episode of The Simpsons titled 'E-I-E-I-(Annoyed Grunt)'. The method used to create the tomacco in the episode is fictional. In the episode, the tomacco was accidentally created by Homer Simpson when he planted and fertilized his tomato and tobacco fields with plutonium. The result is a tomato that apparently has a dried, brown tobacco center, and, although being described as tasting terrible by many characters, is also immediately and powerfully addictive. The creation is promptly labeled 'tomacco' by Homer and sold in large quantities to unsuspecting passersby. A cigarette company, Laramie Tobacco Co., seeing the opportunity to legally sell their products to children, offers to buy the rights to market tomacco, but Homer demands one thousand times as much money as they wish to pay him, and the company withdraws. Eventually, all of the tomacco plants are eaten by farm animals — except for the one remaining plant, which later goes down in an explosive helicopter crash with the cigarette company's lawyers. - From https://en.wikipedia.org/wiki/Products_produced_from_The_Simpsons#Tomacco", 
                "id": 1, 
                "image_url": "http://2.media.bustedtees.cvcdn.com/c/-/bustedtees.f878919c-e3ae-4eba-b8e3-52b300cb.gif", 
                "name": "Tomacco"
            }, 
            "sow_date": "2017-05-28T01:48:06.000Z"
        }
    }
    EOM

    def show
      if @crop
        json_response(@crop)
      else
        json_response({:message => "Couldn't find Crop with id #{params[:id]}"}, :not_found)
      end
    end

    api! 'Creates a new crop'
    description "Creates a new crop having its sow date, container id and product id as parameters. A harvest date is available and it's not mandatory. We recommend use the update to set this parameter when closing the crop."
    param_group :crop
    error :code => 422, :desc => 'Unprocessable entity', :meta => {:problem => 'Missing multiple parameter'}
    example <<-EOM
    POST /v1/producer/crops HTTP/1.1
    Accept: application/json
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=79fb675bcf535b06c96ad2240e259684
    Connection: keep-alive
    Content-Length: 66
    Content-Type: application/json
    
    {
        "container_id": "1", 
        "product_id": "1", 
        "sow_date": "2017-05-01"
    }
    
    HTTP/1.1 201 Created
    Cache-Control: max-age=0, private, must-revalidate
    Content-Type: application/json; charset=utf-8
    ETag: W/"c69fc0571a092f15f9759a229408d5b9"
    Transfer-Encoding: chunked
    Vary: Origin
    X-Request-Id: 69a4cb93-ec1a-4fb6-b42d-7dde17a31f98
    X-Runtime: 0.112116
    
    {
        "data": {
            "container": {
                "id": 1, 
                "name": "Bulto"
            }, 
            "crop_logs": [], 
            "harvest_date": null, 
            "id": 2, 
            "product": {
                "description": "Tomacco was originally a fictional plant that was a hybrid between tomatoes and tobacco, from a 1999 episode of The Simpsons titled 'E-I-E-I-(Annoyed Grunt)'. The method used to create the tomacco in the episode is fictional. In the episode, the tomacco was accidentally created by Homer Simpson when he planted and fertilized his tomato and tobacco fields with plutonium. The result is a tomato that apparently has a dried, brown tobacco center, and, although being described as tasting terrible by many characters, is also immediately and powerfully addictive. The creation is promptly labeled 'tomacco' by Homer and sold in large quantities to unsuspecting passersby. A cigarette company, Laramie Tobacco Co., seeing the opportunity to legally sell their products to children, offers to buy the rights to market tomacco, but Homer demands one thousand times as much money as they wish to pay him, and the company withdraws. Eventually, all of the tomacco plants are eaten by farm animals — except for the one remaining plant, which later goes down in an explosive helicopter crash with the cigarette company's lawyers. - From https://en.wikipedia.org/wiki/Products_produced_from_The_Simpsons#Tomacco", 
                "id": 1, 
                "image_url": "http://2.media.bustedtees.cvcdn.com/c/-/bustedtees.f878919c-e3ae-4eba-b8e3-52b300cb.gif", 
                "name": "Tomacco"
            }, 
            "sow_date": "2017-05-01T00:00:00.000Z"
        }
    }
    EOM

    def create
      json_response(current_user.crops.create!(crop_params), :created)
    end

    api! 'Updates an existing crop'
    description 'Updates an existing crop. Generally used to set the harvest date'
    param_group :crop
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM
    PUT /v1/producer/crops/2 HTTP/1.1
    Accept: application/json
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=79fb675bcf535b06c96ad2240e259684
    Connection: keep-alive
    Content-Length: 44
    Content-Type: application/json
    
    {
        "harvest_date": "2017-05-28T21:01:27.123Z"
    }
    
    HTTP/1.1 204 No Content
    Cache-Control: no-cache
    Vary: Origin
    X-Request-Id: dfd808ed-e8f6-448a-9630-dcba6bfa6179
    X-Runtime: 0.101398
    EOM
    def update
      @crop.update(crop_params)
      head :no_content
    end

    def destroy
      @crop.destroy
      head :no_content
    end

    private

    def crop_params
      params.permit(
          :sow_date,
          :harvest_date,
          :container_id,
          :product_id
      )
    end

    def set_crop
      @crop = current_user.crops.find(params[:id])
    end
  end
end
