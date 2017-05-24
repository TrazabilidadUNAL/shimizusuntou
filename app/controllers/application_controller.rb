class ApplicationController < ActionController::API
  include ActionController::Helpers
  include ActionController::Serialization
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include Concerns::Response
  include Concerns::ExceptionHandler
  include Concerns::Orderable

  before_action :require_login!
  helper_method :user_signed_in?, :current_user

  def require_login!
    return true if authenticate_token
    json_response({errors: [{detail: 'Access denied'}]}, :unauthorized)
  end

  def user_signed_in?
    current_user.present?
  end

  def current_user
    @_current_user ||= authenticate_token
  end

  private
  def authenticate_token
    authenticate_with_http_token do |token, options|
      User.where(auth_token: token).where('token_created_at >= ?', 1.month.ago).first
    end
  end
end
