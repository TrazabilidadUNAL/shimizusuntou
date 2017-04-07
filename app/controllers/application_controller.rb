class ApplicationController < ActionController::API
  include ActionController::Serialization
  include Response
  include ExceptionHandler
end
