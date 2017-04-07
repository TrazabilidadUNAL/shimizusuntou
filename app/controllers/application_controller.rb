class ApplicationController < ActionController::API
  include ActionController::Serialization
  include Response
  include ExceptionHandler

  def not_found
    format.all { head :not_found }
  end
end
