require 'rails_helper'

RSpec.describe Api::V1::ProducersController, type: :request do
  let!(:producers) { create_list(:producer, 10) }
  let(:producer_id) { producers.first.id }

  describe 'GET /v1/producers' do
    it 'should return status code 404' do
      expect { get '/v1/producers' }.to raise_error(ActionController::RoutingError)
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
    let(:fname) { Faker::Name.first_name }
    let(:lname) { Faker::Name.last_name }
    let(:uname) { Faker::Internet.user_name }
    let(:pswrd) { Faker::Internet.password(8) }
    let(:valid_attributes) { {first_name: fname, last_name: lname, username: uname, password: pswrd} }

    context 'when the request is valid' do
      before { post '/v1/producers', params: valid_attributes }

      it 'should create the producer' do
        expect(json['first_name']).to eq(fname)
        expect(json['last_name']).to eq(lname)
        expect(json['username']).to eq(uname)
        expect(json['password']).to eq(pswrd)
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
        expect(response.body).to match(/First name can't be blank, Last name can't be blank, Username can't be blank, Password can't be blank/)
      end
    end
  end

  describe 'PUT /v1/producers/:id' do
    let(:valid_attributes) { {first_name: "Jane"} }

    context 'when the record exists' do
      before { put "/v1/producers/#{producer_id}" , params: valid_attributes }

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

  describe 'GET /v1/producers/:id/places' do
    let(:producer) { create(:producer_with_places, places_count: 15) }

    context 'when the producer has places indeed' do
      before { get "/v1/producers/#{producer.id}/places" }

      it 'should return the places' do
        expect(json).not_to be_empty
        expect(json.size).to eq(15)
      end

      it 'should return status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'POST /v1/producers/:id/places' do
    let(:producer) { create(:producer) }
    let(:tag) { Faker::Address.street_name }
    let(:lon) { Faker::Address.longitude.to_f }
    let(:lat) { Faker::Address.latitude.to_f }
    let(:valid_attributes) { {tag: tag, lat: lat, lon: lon} }

    context 'when the request is valid' do
      before { post "/v1/producers/#{producer.id}/places", params: valid_attributes }

      it 'should create the place' do
        expect(json['tag']).to eq(tag)
        expect(json['lon']).to eq(lon)
        expect(json['lat']).to eq(lat)
        expect(json['localizable_type']).to eq("Producer")
        expect(json['localizable_id']).to eq(producer.id)
      end
    end

    context 'when the request is invalid' do
      before { post "/v1/producers/#{producer.id}/places", params: {tag: "Invalid place"}  }

      it 'should return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'should return a validation failure message' do
        expect(response.body).to match(/Lat can't be blank, Lon can't be blank/)
      end
    end
  end

  describe 'PUT /v1/producers/:id/places/:place_id' do
    let(:places) { create_list(:producer_place, 1) }
    let(:place_id) { places.first.id }
    let(:valid_attributes) { {tag: "Some tag for place"} }

    context 'when the record exists' do
      before { put "/v1/producers/#{producer_id}/places/#{place_id}", params: valid_attributes }

      it 'should update the record\'s place' do
        expect(response.body).to be_empty
      end

      it 'should return status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /v1/producers/:id/places/:place_id' do
    let(:places) { create_list(:producer_place, 2) }
    let(:place_id) { places.first.id }
    before { delete "/v1/producers/#{producer_id}/places/#{place_id}" }

    it 'should return status code 204' do
      expect(response).to have_http_status(204)
    end
  end

end

