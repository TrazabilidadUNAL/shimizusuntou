class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler

  def not_found
    format.all { head :not_found }
  end
end
