module Api
  class SessionsController < ApplicationController
    skip_before_action :require_login!, only: [:create]
    skip_before_action :load_parent, except: []

    api! 'Starts a new session to use the API'
    description '
    Allows a user to start a new session to use the API.
    The session will live up for one month, or when the user decides to end it
    manually using the *sign-out* endpoint. The token at the response must be used
    in every request as a header:

    Authorization: Token token=b782494fb658ba74b07f414f51fd1008
    '
    formats ['json']
    error code: 401, desc: 'There is an error with either you email or password'
    param :user_login, Hash, desc: 'Session login object', required: true do
      param :email, String, desc: "User's email", required: true
      param :password, String, desc: "User's password", required: true
    end
    example <<-EOM
    POST /sign-in HTTP/1.1
    Accept: application/json
    Accept-Encoding: gzip, deflate
    Connection: keep-alive
    Content-Length: 76
    Content-Type: application/json
    
    {
        "user_login": {
            "email": "user@provider.com",
            "password": "SuperSecurePassword"
        }
    }
    
    HTTP/1.1 200 OK
    Cache-Control: max-age=0, private, must-revalidate
    Content-Type: application/json; charset=utf-8
    ETag: W/"814f495c575891543cbe418b8df5d03a"
    Transfer-Encoding: chunked
    Vary: Origin
    X-Request-Id: 6e90a042-9392-412b-bc2f-aa3694ca046b
    X-Runtime: 0.013186
    
    {
        "token": "b782494fb658ba74b07f414f51fd1008"
    }
    EOM

    def create
      resource = User.find_by(email: params[:user_login][:email])
      return invalid_login_attempt unless resource

      if resource.valid_password?(params[:user_login][:password])
        auth_token = resource.generate_auth_token
        json_response({token: auth_token})
      else
        invalid_login_attempt
      end
    end

    api! 'Ends a session used in the API'
    description 'Forces a session to be ended.'
    formats ['json']
    error code: 401, desc: "You haven't provided the token in the request's headers"
    example <<-EOM
    DELETE /sign-out HTTP/1.1
    Accept: */*
    Accept-Encoding: gzip, deflate
    Connection: keep-alive
    Content-Length: 0
    authorization:  Token token=b782494fb658ba74b07f414f51fd1008
    
    
    
    HTTP/1.1 200 OK
    Cache-Control: no-cache
    Content-Type: text/html
    Transfer-Encoding: chunked
    Vary: Origin
    X-Request-Id: 2475739c-f7f8-4f69-85f7-1ec743e23d5d
    X-Runtime: 0.271955
    EOM
    def destroy
      resource = current_user
      resource.invalidate_auth_token
      head :ok
    end

    private
    def invalid_login_attempt
      json_response({errors: [{detail: 'Error with your login or password'}]}, :unauthorized)
    end
  end
end