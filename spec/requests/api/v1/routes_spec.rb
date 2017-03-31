require 'rails_helper'

RSpec.describe Api::V1::RoutesController, type: :request do
  let!(:routes) { create_list(:route, 10) }
  let(:route_id) { routes.first.id }

  describe 'GET /v1/routes' do
    before { get '/v1/routes' }

    it 'should return routes' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'should return status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /v1/routes/:id' do
    before { get "/v1/routes/#{route_id}" }

    context 'when the record exists' do
      it 'should return the route' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(route_id)
      end

      it 'should return status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:route_id) { 101 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Route/)
      end
    end
  end

  describe 'POST /v1/routes' do
    let(:origin) { create(:place) }
    let(:destination) { create(:place) }
    let(:valid_attributes) { {origin_id: origin.id, destination_id: destination.id} }

    context 'when the request is valid' do
      before { post '/v1/routes', params: valid_attributes }

      it 'should create the route' do
        expect(json['origin_id']).to eq(origin.id)
        expect(json['destination_id']).to eq(destination.id)
      end

      it 'should return status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/v1/routes', params: {name: Faker::StarWars.character} }

      it 'should return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'should return a validation failure message' do
        expect(response.body).to match(/Origin must exist, Destination must exist/)
      end
    end
  end
  describe 'PUT /v1/routes/:id' do
    let(:origin) { create(:place) }
    let(:valid_attributes) { {origin_id: origin.id} }

    context 'when the record exists' do
      before { put "/v1/routes/#{route_id}", params: valid_attributes }

      it 'should update the record' do
        expect(response.body).to be_empty
      end

      it 'should return status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /v1/routes/:id' do
    before { delete "/v1/routes/#{route_id}" }

    it 'should return status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end