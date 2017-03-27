require 'rails_helper'

RSpec.describe Api::V1::PlacesController, type: :request do
  let!(:places) { create_list(:place, 10) }
  let(:place_id) { places.first.id }

  describe 'GET /v1/places' do
    before { get '/v1/places' }

    it 'should return places' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'should return status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /v1/places/:id' do
    before { get "/v1/places/#{place_id}" }

    context 'when the record exists' do
      it 'should return the place' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(place_id)
      end

      it 'should return status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:place_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Place/)
      end
    end
  end

  describe 'POST /v1/places' do
    let(:tag) { Faker::Address.street_name }
    let(:lat) { Faker::Address.latitude.to_f }
    let(:lon) { Faker::Address.longitude.to_f }
    let(:valid_attributes) { {tag: tag, lat: lat, lon: lon} }

    context 'when the request is valid' do
      before { post '/v1/places', params: valid_attributes }

      it 'should create a place' do
        expect(json['tag']).to eq(tag)
        expect(json['lat']).to eq(lat)
        expect(json['lon']).to eq(lon)
      end

      it 'should return status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the reques is invalid' do
      before { post '/v1/places', params: {tag: 'My farm'} }

      it 'should return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'should return a validation failure message' do
        expect(response.body).to match(/Validation failed: Lat can't be blank, Lon can't be blank/)
      end
    end
  end

  describe 'PUT /v1/places/:id' do
    let(:valid_attributes) { {tag: "My farm", lat: -74.110642, lon: 4.712504} }

    context 'when the record exists' do
      before { put "/v1/places/#{place_id}", params: valid_attributes }

      it 'should update the record' do
        expect(response.body).to be_empty
      end

      it 'should return status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /v1/places/:id' do
    before { delete "/v1/places/#{place_id}" }

    it 'should return status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end