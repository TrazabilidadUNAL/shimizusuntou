require 'rails_helper'

RSpec.describe Api::V1::ProducersController, type: :request do
  let!(:producers) { create_list(:producer, 10) }
  let(:producer_id) { producers.first.id }

  describe 'GET /v1/producers' do
    before { get '/v1/producers' }

    it 'should return producers' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'should return status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /v1/producers/:id' do
    before { get "/v1/producers/#{producer_id}" }

    context 'when the record exists' do
      it 'should return the producer' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(producer_id)
      end

      it 'should return status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:producer_id) { 100 }

      it 'should return status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'should return a not found message' do
        expect(response.body).to match(/Couldn't find Producer/)
      end
    end
  end

  describe 'POST /v1/producer' do
    let(:place) { create(:place) }
    let(:fname) { Faker::Name.first_name }
    let(:lname) { Faker::Name.last_name }
    let(:uname) { Faker::Internet.user_name }
    let(:pswrd) { Faker::Internet.password(8) }
    let(:valid_attributes) { {place_id: place.id, first_name: fname, last_name: lname, username: uname, password: pswrd} }

    context 'when the request is valid' do
      before { post '/v1/producers', params: valid_attributes }

      it 'should create the producer' do
        expect(json['first_name']).to eq(fname)
        expect(json['last_name']).to eq(lname)
        expect(json['username']).to eq(uname)
        expect(json['password']).to eq(pswrd)
        expect(json['place_id']).to eq(place.id)
      end

      it 'should return status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/v1/producers', params: {name: "John"} }

      it 'should return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'should return a validation failure message' do
        expect(response.body).to match(/Place must exist, First name can't be blank, Last name can't be blank, Username can't be blank, Password can't be blank/)
      end
    end
  end

  describe 'PUT /v1/producers/:id' do
    let(:valid_attributes) { {first_name: "Jane"} }

    context 'when the record exists' do
      before { put "/v1/producers/#{producer_id}", params: valid_attributes }

      it 'should update the record' do
        expect(response.body).to be_empty
      end

      it 'should return status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /v1/producers/:id' do
    before { delete "/v1/producers/#{producer_id}" }

    it 'should return status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end