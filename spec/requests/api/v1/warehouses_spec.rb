require 'rails_helper'

RSpec.describe Api::V1::WarehousesController, type: :request do
  let!(:warehouses) {create_list(:warehouse, 10)}
  let(:warehouse_id) {warehouses.first.id}
  let(:warehouse) {warehouses.first}

  describe 'GET /v1/warehouses' do
    it 'should return status code 404' do
      expect {get '/v1/warehouses'}.to raise_error(ActionController::RoutingError)
    end
  end

  describe 'GET /v1/warehouses/:id' do
    before {
      warehouse.generate_auth_token
      get "/v1/warehouses/#{warehouse_id}", headers: {'Authorization' => "Token token=#{warehouse.auth_token}"}
    }

    context 'when the record exists' do
      it 'should return the warehouse' do
        expect(json).not_to be_empty
        expect(json['data']['id']).to eq(warehouse_id)
      end

      it 'should return status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:warehouse_id) {100}

      it 'should return status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'should return a not found message' do
        expect(response.body).to match(/Couldn't find Warehouse/)
      end
    end
  end

  describe 'POST /v1/warehouse' do
    let(:wname) {Faker::Name.name}
    let(:uname) {Faker::Internet.user_name}
    let(:pswrd) {Faker::Internet.password(8)}
    let(:email) {Faker::Internet.email}
    let(:valid_attributes) {{name: wname, username: uname, password: pswrd, email: email}}

    context 'when the request is valid' do
      before {post '/v1/warehouses', params: valid_attributes}

      it 'should create the warehouse' do
        expect(json['data']['name']).to eq(wname)
        expect(json['data']['username']).to eq(uname)
        expect(json['data']['email']).to eq(email)
      end

      it 'should return status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before {post '/v1/warehouses', params: {name: "John"}}

      it 'should return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'should return a validation failure message' do
        expect(response.body).to match(/Username can't be blank, Password can't be blank/)
      end
    end
  end

  describe 'PUT /v1/warehouses/:id' do
    let(:valid_attributes) {{name: "Jane"}}

    context 'when the record exists' do
      before {
        warehouse.generate_auth_token
        put "/v1/warehouses/#{warehouse_id}", params: valid_attributes, headers: {'Authorization' => "Token token=#{warehouse.auth_token}"}
      }

      it 'should update the record' do
        expect(response.body).to be_empty
      end

      it 'should return status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /v1/warehouses/:id' do
    before {
      warehouse.generate_auth_token
      delete "/v1/warehouses/#{warehouse_id}", headers: {'Authorization' => "Token token=#{warehouse.auth_token}"}
    }

    it 'should return status code 204' do
      expect(response).to have_http_status(204)
    end
  end

  describe 'GET /v1/warehouses/:id/places' do
    let(:warehouse) {create(:warehouse_with_place, places_count: 15)}

    context 'when the warehouse has places indeed' do
      before {
        warehouse.generate_auth_token
        get "/v1/warehouses/#{warehouse.id}/places", headers: {'Authorization' => "Token token=#{warehouse.auth_token}"}
      }

      it 'should return the places' do
        expect(json).not_to be_empty
        expect(json['data'].size).to eq(15)
      end

      it 'should return status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'POST /v1/warehouses/:id/places' do
    let(:warehouse) {create(:warehouse)}
    let(:tag) {Faker::Address.street_name}
    let(:lon) {Faker::Address.longitude.to_f}
    let(:lat) {Faker::Address.latitude.to_f}
    let(:valid_attributes) {{tag: tag, lat: lat, lon: lon}}

    context 'when the request is valid' do
      before {
        warehouse.generate_auth_token
        post "/v1/warehouses/#{warehouse.id}/places", params: valid_attributes, headers: {'Authorization' => "Token token=#{warehouse.auth_token}"}
      }
      it 'should create the place' do
        expect(json['data']['tag']).to eq(tag)
        expect(json['data']['lon']).to eq(lon)
        expect(json['data']['lat']).to eq(lat)
      end
    end

    context 'when the request is invalid' do
      before {
        warehouse.generate_auth_token
        post "/v1/warehouses/#{warehouse.id}/places", params: {tag: "Invalid place"}, headers: {'Authorization' => "Token token=#{warehouse.auth_token}"}
      }

      it 'should return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'should return a validation failure message' do
        expect(response.body).to match(/Lat can't be blank, Lon can't be blank/)
      end
    end

  end

  describe 'PUT /v1/warehouses/:id/places/:place_id' do
    let(:places) {create_list(:warehouse_place, 1)}
    let(:place_id) {places.first.id}
    let(:valid_attributes) {{tag: "Some tag for place"}}

    context 'when the record exists' do
      before {
        warehouse.generate_auth_token
        put "/v1/warehouses/#{warehouse_id}/places/#{place_id}", params: valid_attributes, headers: {'Authorization' => "Token token=#{warehouse.auth_token}"}
      }

      it 'should update the record\'s place' do
        expect(response.body).to be_empty
      end

      it 'should return status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /v1/warehouses/:id/places/:place_id' do
    let(:places) {create_list(:warehouse_place, 2)}
    let(:place_id) {places.first.id}
    before {
      warehouse.generate_auth_token
      delete "/v1/warehouses/#{warehouse_id}/places/#{place_id}", headers: {'Authorization' => "Token token=#{warehouse.auth_token}"}
    }

    it 'should return status code 204' do
      expect(response).to have_http_status(204)
    end
  end

end