require 'rails_helper'

RSpec.describe Api::V1::PackagesController, type: :request do

  let!(:packages) { create_list(:package, 10) }
  let(:package_id) { packages.first.id }

  describe 'GET /v1/packages' do
    before { get '/v1/packages' }

    it 'should return packages' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'should return status code 200' do
      expect(response).to have_http_status(200)
    end

  end

  describe 'GET /v1/packages/:id' do
    before { get "/v1/packages/#{package_id}" }

    context 'when the record exists' do
      it 'should return the package' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(package_id)
      end

      it 'should return status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:package_id) { 100 }

      it 'should return status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'should return a not found message' do
        expect(response.body).to match(/Couldn't find Package/)
      end
    end
  end

  describe 'POST /v1/packages' do
    let(:crop) { create(:crop) }
    let(:route) { create(:route)}
    let(:package) { create(:package)}
    let(:quantity) { Faker::Number.positive }
    let(:valid_attributes) { {parent_id: package.id, crop_id: crop.id, route_id: route.id, quantity: quantity} }
    # let(:valid_attributes) { { crop_id: crop.id, route_id: route.id, quantity: quantity} }

    context 'when the request is valid' do
      before { post '/v1/packages', params: valid_attributes }

      it 'should create the package' do
        expect(json['parent_id']).to eq(package.id)
        expect(json['crop_id']).to eq(crop.id)
        expect(json['route_id']).to eq(route.id)
        expect(json['quantity']).to eq(quantity)
      end

      it 'should return status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/v1/packages', params: {crop_id: 150} }

      it 'should return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'should return a validation failure message' do
        expect(response.body).to match(/Crop must exist, Parent_id must exist, Route must exist, Quantity can't be blank/)
      end
    end
  end

  describe 'PUT /v1/packages/:id' do
    let(:valid_attributes) { { quantity: 46543.04} }

    context 'when the record exists' do
      before { put "/v1/places/#{package_id}", params: valid_attributes }

      it 'should update the record' do
        expect(response.body).to be_empty
      end

      it 'should return status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /v1/packages/:id' do
    before { delete "/v1/packages/#{package_id}" }

    it 'should return status code 204' do
      expect(response).to have_http_status(204)
    end
  end

end

