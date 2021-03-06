require 'rails_helper'

RSpec.describe Api::V1::ProducersController, type: :request do
  let!(:producers) {create_list(:producer, 10)}
  let(:producer_id) {producers.first.id}
  let(:producer) {producers.first}

  describe 'GET /v1/producers' do
    it 'should return status code 404' do
      expect {get '/v1/producers'}.to raise_error(ActionController::RoutingError)
    end
  end

  describe 'GET /v1/producers/:id' do
    before {
      producer.generate_auth_token
      get "/v1/producers/#{producer_id}", headers: {'Authorization' => "Token token=#{producer.auth_token}"}
    }

    context 'when the record exists' do
      it 'should return the producer' do
        expect(json).not_to be_empty
        expect(json['data']['id']).to eq(producer_id)
      end

      it 'should return status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:producer_id) {100}

      it 'should return status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'should return a not found message' do
        expect(response.body).to match(/Couldn't find Producer/)
      end
    end
  end

  describe 'POST /v1/producer' do
    let(:fname) {Faker::Name.first_name}
    let(:lname) {Faker::Name.last_name}
    let(:uname) {Faker::Internet.user_name}
    let(:pswrd) {Faker::Internet.password(8)}
    let(:email) {Faker::Internet.email}
    let(:valid_attributes) {{first_name: fname, last_name: lname, username: uname, password: pswrd, email: email}}

    context 'when the request is valid' do
      before {post '/v1/producers', params: valid_attributes}

      it 'should create the producer' do
        expect(json['data']['first_name']).to eq(fname)
        expect(json['data']['last_name']).to eq(lname)
        expect(json['data']['username']).to eq(uname)
        expect(json['data']['email']).to eq(email)
      end

      it 'should return status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before {
        producer.generate_auth_token
        post '/v1/producers', params: {name: "John"}, headers: {'Authorization' => "Token token=#{producer.auth_token}"}
      }

      it 'should return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'should return a validation failure message' do
        expect(response.body).to match(/Username can't be blank, Password can't be blank, First name can't be blank, Last name can't be blank/)
      end
    end
  end

  describe 'PUT /v1/producers/:id' do
    let(:valid_attributes) {{first_name: "Jane"}}

    context 'when the record exists' do
      before {
        producer.generate_auth_token
        put "/v1/producers/#{producer_id}", params: valid_attributes, headers: {'Authorization' => "Token token=#{producer.auth_token}"}
      }

      it 'should update the record' do
        expect(response.body).to be_empty
      end

      it 'should return status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /v1/producers/:id' do
    before {
      producer.generate_auth_token
      delete "/v1/producers/#{producer_id}", headers: {'Authorization' => "Token token=#{producer.auth_token}"}
    }

    it 'should return status code 204' do
      expect(response).to have_http_status(204)
    end
  end

  describe 'GET /v1/producers/:id/places' do
    let(:producer) {create(:producer_with_places, places_count: 15)}

    context 'when the producer has places indeed' do
      before {
        producer.generate_auth_token
        get "/v1/producers/#{producer.id}/places", headers: {'Authorization' => "Token token=#{producer.auth_token}"}
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

  describe 'POST /v1/producers/:id/places' do
    let(:producer) {create(:producer)}
    let(:tag) {Faker::Address.street_name}
    let(:lon) {Faker::Address.longitude.to_f}
    let(:lat) {Faker::Address.latitude.to_f}
    let(:valid_attributes) {{tag: tag, lat: lat, lon: lon}}

    context 'when the request is valid' do
      before {
        producer.generate_auth_token
        post "/v1/producers/#{producer.id}/places", params: valid_attributes, headers: {'Authorization' => "Token token=#{producer.auth_token}"}
      }

      it 'should create the place' do
        expect(json['data']['tag']).to eq(tag)
        expect(json['data']['lon']).to eq(lon)
        expect(json['data']['lat']).to eq(lat)
      end
    end

    context 'when the request is invalid' do
      before {
        producer.generate_auth_token
        post "/v1/producers/#{producer.id}/places", params: {tag: "Invalid place"}, headers: {'Authorization' => "Token token=#{producer.auth_token}"}
      }

      it 'should return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'should return a validation failure message' do
        expect(response.body).to match(/Lat can't be blank, Lon can't be blank/)
      end
    end
  end

  describe 'PUT /v1/producers/:id/places/:place_id' do
    let(:places) {create_list(:producer_place, 1)}
    let(:place_id) {places.first.id}
    let(:valid_attributes) {{tag: "Some tag for place"}}

    context 'when the record exists' do
      before {
        producer.generate_auth_token
        put "/v1/producers/#{producer_id}/places/#{place_id}", params: valid_attributes, headers: {'Authorization' => "Token token=#{producer.auth_token}"}
      }

      it 'should update the record\'s place' do
        expect(response.body).to be_empty
      end

      it 'should return status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /v1/producers/:id/places/:place_id' do
    let(:places) {create_list(:producer_place, 2)}
    let(:place_id) {places.first.id}
    before {
      producer.generate_auth_token
      delete "/v1/producers/#{producer_id}/places/#{place_id}", headers: {'Authorization' => "Token token=#{producer.auth_token}"}
    }

    it 'should return status code 204' do
      expect(response).to have_http_status(204)
    end
  end

end

