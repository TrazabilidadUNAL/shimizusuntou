require 'rails_helper'

RSpec.describe Api::V1::ContainersController, type: :request do
  let!(:containers) { create_list(:container, 10) }
  let(:container_id) { containers.first.id }

  describe 'GET /v1/containers' do
    before { get '/v1/containers' }

    it 'should return containers' do
      expect(json).not_to be_empty
      expect(json['data'].size).to eq(10)
    end

    it 'should return status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /v1/containers/:id' do
    before { get "/v1/containers/#{container_id}" }

    context 'when the record exists' do
      it 'should return the container' do
        expect(json).not_to be_empty
        expect(json['data']['id']).to eq(container_id)
      end

      it 'should return status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:container_id) { 100 }

      it 'should return status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'should return a not found message' do
        expect(response.body).to match(/Couldn't find Container/)
      end
    end
  end

  describe 'POST /v1/containers' do
    let(:valid_attributes) { {name: 'Millenium Falcon'} }

    context 'when the request is valid' do
      before { post '/v1/containers', params: valid_attributes }

      it 'should create a container' do
        expect(json['data']['name']).to eq('Millenium Falcon')
      end

      it 'should return status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/v1/containers', params: {naem: "Millenium Falcon"} }

      it 'should return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'should return a validation failure message' do
        expect(response.body).to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  describe 'PUT /v1/containers/:id' do
    let(:valid_attributes) { {name: 'Millenium Falcon'} }

    context 'when the record exists' do
      before { put "/v1/containers/#{container_id}", params: valid_attributes }

      it 'should update the record' do
        expect(response.body).to be_empty
      end

      it 'should returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /v1/containers/:id' do
    before { delete "/v1/containers/#{container_id}" }

    it 'should return status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end