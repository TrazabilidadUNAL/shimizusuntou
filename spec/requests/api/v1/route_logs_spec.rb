require 'rails_helper'

RSpec.describe Api::V1::RouteLogsController, type: :request do
  let!(:route_logs) { create_list(:route_log, 10) }
  let(:route_log_id) { route_logs.first.id }

  describe 'GET /v1/route_logs' do
    before { get '/v1/route_logs' }

    it 'should return route logs' do
      expect(json).not_to be_empty
      expect(json['data'].size).to eq(10)
    end

    it 'should return status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /v1/route_logs/:id' do
    before { get "/v1/route_logs/#{route_log_id}" }

    context 'when the record exists' do
      it 'should return the route log' do
        expect(json).not_to be_empty
        expect(json['data']['id']).to eq(route_log_id)
      end

      it 'should return status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:route_log_id) { 100 }

      it 'should return status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'should return a not found message' do
        expect(response.body).to match(/Couldn't find RouteLog/)
      end
    end
  end

  describe 'POST /v1/route_logs' do
    let(:route) { create(:route) }
    let(:temperature) { Faker::Number.between(0.0, 100.0) }
    let(:humidity) { Faker::Number.between(0.0, 100.0)  }
    let(:lat) { Faker::Address.latitude.to_f }
    let(:lon) { Faker::Address.longitude.to_f }
    let(:valid_attributes) { {route_id: route.id, temperature: temperature, humidity: humidity, lat: lat, lon: lon} }

    context 'when the request is valid' do
      before { post '/v1/route_logs', params: valid_attributes }

      it 'should create the route log' do
        expect(json['data']['temperature']).to eq(temperature)
        expect(json['data']['humidity']).to eq(humidity)
        expect(json['data']['lat']).to eq(lat)
        expect(json['data']['lon']).to eq(lon)
      end

      it 'should return status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/v1/route_logs', params: {lat: Faker::Address.latitude.to_f} }

      it 'should return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'should return a validation failure message' do
        expect(response.body).to match(/Route must exist, Temperature can't be blank, Humidity can't be blank, Lon can't be blank/)
      end
    end
  end

  describe 'PUT /v1/route_logs/:id' do
    let(:valid_attributes) { {temperature: 20.0, humidity: 30.0 , lat: -74.110642, lon: 4.712504} }

    context 'when the record exists' do
      before { put "/v1/route_logs/#{route_log_id}" }

      it 'should update the record' do
        expect(response.body).to be_empty
      end

      it 'should return status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /v1/route_logs/:id' do
    before { delete "/v1/route_logs/#{route_log_id}" }

    it 'should return status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end