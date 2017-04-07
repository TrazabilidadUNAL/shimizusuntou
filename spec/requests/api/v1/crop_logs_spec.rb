require 'rails_helper'

RSpec.describe Api::V1::CropLogsController, type: :request do
  let!(:crop_logs) { create_list(:crop_log, 10) }
  let(:crop_log_id) { crop_logs.first.id }

  describe 'GET /v1/crop_logs' do
    before { get '/v1/crop_logs' }

    it 'should return crop logs' do
      expect(json).not_to be_empty
      expect(json['data'].size).to eq(10)
    end

    it 'should return status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /v1/crop_logs/:id' do
    before { get "/v1/crop_logs/#{crop_log_id}" }

    context 'when the record exists' do
      it 'should return the crop log' do
        expect(json).not_to be_empty
        expect(json['data']['id']).to eq(crop_log_id)
      end

      it 'should return status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:crop_log_id) { 100 }

      it 'should return status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'should return a not found message' do
        expect(response.body).to match(/Couldn't find CropLog/)
      end
    end
  end

  describe 'POST /v1/crop_logs' do
    let(:crop) { create(:crop) }
    let(:description) { Faker::StarWars.quote }
    let(:valid_attributes) { {description: description, crop_id: crop.id} }

    context 'when the request is valid' do
      before { post '/v1/crop_logs', params: valid_attributes }

      it 'should create the crop log' do
        expect(json['data']['description']).to eq(description)
      end

      it 'should return status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/v1/crop_logs', params: {description: Faker::StarWars.quote} }

      it 'should return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'should return a validation failure message' do
        expect(response.body).to match(/Crop must exist/)
      end
    end
  end

  describe 'PUT /v1/crop_logs/:id' do
    let(:valid_attributes) { {description: Faker::StarWars.quote} }

    context 'when the record exists' do
      before { put "/v1/crop_logs/#{crop_log_id}" }

      it 'should update the record' do
        expect(response.body).to be_empty
      end

      it 'should return status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /v1/crop_logs/:id' do
    before { delete "/v1/crop_logs/#{crop_log_id}" }

    it 'should return status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end