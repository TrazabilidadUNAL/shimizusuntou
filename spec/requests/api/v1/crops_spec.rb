require 'rails_helper'

RSpec.describe Api::V1::CropsController, type: :request do
  let!(:crops) { create_list(:crop, 10) }
  let(:crop_id) { crops.first.id }

  describe 'GET /v1/crops' do
    before { get '/v1/crops' }

    it 'should return crops' do
      expect(json).not_to be_empty
      expect(json['data'].size).to eq(10)
    end

    it 'should return status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /v1/crops/:id' do
    before { get "/v1/crops/#{crop_id}" }

    context 'when the record exists' do
      it 'should return the crop' do
        expect(json).not_to be_empty
        expect(json['data']['id']).to eq(crop_id)
      end

      it 'should return status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:crop_id) { 100 }

      it 'should return status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'should return a not found message' do
        expect(response.body).to match(/Couldn't find Crop/)
      end
    end
  end

  describe 'POST /v1/crops' do
    let(:container) { create(:container) }
    let(:product) { create(:product) }
    let(:producer) { create(:producer) }
    let(:sow_date) { Date.today.iso8601 }
    let(:valid_attributes) { {sow_date: sow_date, container_id: container.id, product_id: product.id, producer_id: producer.id} }

    context 'when the request is valid' do
      before { post '/v1/crops', params: valid_attributes }

      it 'should create the crop' do
        expect(json['data']['sow_date']).to eq("#{sow_date}T00:00:00.000Z")
        expect(json['data']['container_id']).to eq(container.id)
        expect(json['data']['product_id']).to eq(product.id)
        expect(json['data']['producer_id']).to eq(producer.id)
      end

      it 'should return status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/v1/crops', params: {name: Faker::StarWars.character} }

      it 'should return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'should return a validation failure message' do
        expect(response.body).to match(/Container must exist, Product must exist, Producer must exist, Sow date can't be blank/)
      end
    end
  end

  describe 'PUT /v1/crops/:id' do
    let(:valid_attributes) { {harvest_date: Faker::Date.forward(1)} }

    context 'when the record exists' do
      before { put "/v1/crops/#{crop_id}", params: valid_attributes }

      it 'should update the record' do
        expect(response.body).to be_empty
      end

      it 'should return status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /v1/crops/:id' do
    before { delete "/v1/crops/#{crop_id}" }

    it 'should return status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end