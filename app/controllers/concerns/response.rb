module Concerns
  module Response
    def json_response(object, status = :ok, include = '*')
      render json: object, status: status, root: 'data', include: include
    end
  end
end