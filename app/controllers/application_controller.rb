class ApplicationController < ActionController::API
  include ActionController::Serialization
  include Concerns::Response
  include Concerns::ExceptionHandler
end
