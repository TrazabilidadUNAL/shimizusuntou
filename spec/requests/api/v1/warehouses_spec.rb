require 'rails_helper'

RSpec.describe Api::V1::WarehousesController, type: :request do
  let!(:warehouses) { create_list(:warehouse, 10) }
  let(:warehouse_id) { warehouses.first.id }

  describe 'GET /v1/warehouses' do
    it 'should return status code 404' do
      expect { get '/v1/warehouses' }.to raise_error(ActionController::RoutingError)
    end
  end

  describe 'GET /v1/warehouses/:id' do
    before { get "/v1/warehouses/#{warehouse_id}" }

    context 'when the record exists' do
      it 'should return the warehouse' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(warehouse_id)
      end

      it 'should return status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:warehouse_id) { 100 }

      it 'should return status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'should return a not found message' do
        expect(response.body).to match(/Couldn't find Warehouse/)
      end
    end
  end

  describe 'GET /v1/warehouses/:id/places' do
    let(:warehouse) { create(:warehouse_with_place, places_count: 15) }

    context 'when the warehouse has places indeed' do
      before { get "/v1/warehouses/#{warehouse.id}/places" }

      it 'should return the places' do
        expect(json).not_to be_empty
        expect(json.size).to eq(15)
      end

      it 'should return status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'POST /v1/warehouse' do
    let(:wname) { Faker::Name.name }
    let(:uname) { Faker::Internet.user_name }
    let(:pswrd) { Faker::Internet.password(8) }
    let(:valid_attributes) { {name: wname, username: uname, password: pswrd} }

    context 'when the request is valid' do
      before { post '/v1/warehouses', params: valid_attributes }

      it 'should create the warehouse' do
        expect(json['name']).to eq(wname)
        expect(json['username']).to eq(uname)
        expect(json['password']).to eq(pswrd)
      end

      it 'should return status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/v1/warehouses', params: {name: "John"} }

      it 'should return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'should return a validation failure message' do
        expect(response.body).to match(/Username can't be blank, Password can't be blank/)
      end
    end
  end

  describe 'POST /v1/warehouses/:id/places' do
    let(:warehouse) { create(:warehouse) }
    let(:tag) { Faker::Address.street_name }
    let(:lon) { Faker::Address.longitude.to_f }
    let(:lat) { Faker::Address.latitude.to_f }
    let(:valid_attributes) { {tag: tag, lat: lat, lon: lon} }

    context 'when the request is valid' do
      before { post "/v1/warehouses/#{warehouse.id}/places", params: valid_attributes }
      it 'should create the place' do
        expect(json['tag']).to eq(tag)
        expect(json['lon']).to eq(lon)
        expect(json['lat']).to eq(lat)
        expect(json['localizable_type']).to eq("Warehouse")
        expect(json['localizable_id']).to eq(warehouse.id)
      end
    end
  end

  describe 'PUT /v1/warehouses/:id' do
    let(:valid_attributes) { {name: "Jane"} }

    context 'when the record exists' do
      before { put "/v1/warehouses/#{warehouse_id}", params: valid_attributes }

      it 'should update the record' do
        expect(response.body).to be_empty
      end

      it 'should return status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /v1/warehouses/:id' do
    before { delete "/v1/warehouses/#{warehouse_id}" }

    it 'should return status code 204' do
      expect(response).to have_http_status(204)
    end
  end


end