module Api
  class SessionsController < ApplicationController
    skip_before_action :require_login!, only: [:create]

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