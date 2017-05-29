module Api::V1
  class PackagesController < ApplicationController
    before_action :set_package, only: [:show, :update, :destroy]

    has_scope :q, only: :index

    resource_description do
      desc <<-EOD
      Packages are the simplest way to put a shipment from an Origin to a Destination 
      of a Product packed in a Container. It tells how many units were packed, and also 
      if it comes from a previous packages, very useful when tracking a Product's origin.
      EOD
    end

    def_param_group :package do
      param :crop_id, Integer, 'Related crop for this package', required: true
      param :route_id, Integer, 'Related routed for this package', required: true
      param :quantity, Integer, 'Amount of containers of certain product packed in this package', required: true
      param :parent_id, Intger, "Tells what's the parent package for this package if it does exist."
    end

    api! 'Shows all packages for a given user.'
    description 'Shows all related packages for a given user. Creates a QRCode in the qr_code field depending on where it was called.'
    formats ['json']
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM
    GET /v1/producer/packages HTTP/1.1
    Accept: */*
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=79fb675bcf535b06c96ad2240e259684
    Connection: keep-alive
    
    
    
    HTTP/1.1 200 OK
    Cache-Control: max-age=0, private, must-revalidate
    Content-Type: application/json; charset=utf-8
    ETag: W/"8f68c57bd95e341b71aa4a0d7f5f9763"
    Transfer-Encoding: chunked
    Vary: Origin
    X-Request-Id: 30d23e3e-38e0-4c66-a01b-ad31d90be324
    X-Runtime: 1.021642
    
    {
        "data": [
            {
                "crop_id": 1, 
                "id": 1, 
                "parent_id": null, 
                "qr_code": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAMgAAADIAQAAAACFI5MzAAADAElEQVR4nO1XQW6jQBDs8ViCG/mAgTwDCQxRXuQbSE4YEkvDLS+KFttIfoYZ/IFwAwnc2949O9LG2zllThYldbtmuqurZ3jtzODa+UG+FRFC2FAIBdO8BjCeb+gLQx4HUUGuRQIh1DtXNALxg4Mp0YEhw+qwCbJYHn0w4oZoX0QGlatttIbDGeWOMU9pZSLfF1YFHjFlyoM9pIVWUxIGa7H1XfCQI08nhHrTttTVQW92wuxQiDuGPKQ+/eWFYFoHCSx8ooPIUomqUCs1ZQkcKmhhMWtviXYVEZadrpx+XYcQRM/iOEPfdBx8+pUNgy1H+Z7AzvUMNuCw3JvTl1a/qbcJxFVrPG/pcfDBPi3zTmWPldxsnxdL+sJSb2BlVG9vKsiLtXyhGmhvinYVuRvUm12u5vJ9LUe8lHXjsSjsVeTD0Z1K30aQ+/fowZjj7NRw3GjXZfbg9LIQiawiH05n9Fk62FF5n0KRxIWY/3k3Fzj4eACkr8MYV2EYwmKJ/qlheTkS8rK0Xjf1QeuqbcUxYpn1ZtCOGrJ5QNI3PeDkn3bAwceBosuQBlMdJPIFWhfvkaWDHW1bmR7ri5AvW69xXcOhfB35lkwrOdKgnWZweaCY5d56KFMoC2uvqxCjKCLX9/Vo15E7GkyqhPxdRJF1/qt8HPXWWWQc+rRIwrgKZAMns/tm5XMGldIvOdZTAtF9g55/6er/31lgkb8dnh5Ra00VTxp/Q7RPEKSZVVrUWlMUPTRkLl3DcaMeWEQne90XicRfni+2980N//oq8gEFzWBYT4/7CuIz0HhkUfLOhnKl9ZM1whTNWlpzW+DwLk6foz0oPcxB6jMIgzxK8Wc7hDJLyPyH4G39llZEDj60HaZ5Zu334zQHEzfupX04vKVNHaSy+ZSQlHsNCt8YJqUoSQ+qcEqCWHj3aHgm0+WkOdEhW/6KjYtLlkn7CULL1MrJVFhvRYIzauAdi/JdtkNYKZC4r2pxbkVDmxvHVkDboaX1CBDG4xJcFwSPF/tB/h35DYy1goeVQE9qAAAAAElFTkSuQmCC", 
                "quantity": 40.0, 
                "route_id": 1
            }, 
            {
                "crop_id": 1, 
                "id": 2, 
                "parent_id": null, 
                "qr_code": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAMgAAADIAQAAAACFI5MzAAADAElEQVR4nO1XzYqjQBCuUkFvzgvEuI8RUFvwiXJTyGx0JmBueaKARsHHWHVeYL11g6a23HsGdrK9p20v0h9Udf19VWXQo2PAo/Mf+acIIjqg0Fpi/gyOy8A3GvS4RLnKIYtbs4gByEeinzosZXPOkEI313ELeAc26AlpX0TsssyXWFSiIrPXqCc9F3ZTWAFEuBi69JAElcnlIFRyjQF72JIOPRNifind91Pbnbq3cQRCfNGgh9lHppyKu0Owy4S/8bd8o8NvyikymnKAxW4q8j026AlpjxFHSTu3c1isxYLtDcgkHX57seVZZdlr0tC84zy4YT888epPEJtyuLwX8ZKcRB0RhkILU0g4ny/TawxmJd7wBjj0kxZGyvelhOMMNXMseB6MWvz2UypnzesWxDVmrxkeCR16PkGci4SLi8ci7ioSw9BjrSMT0Z6cIuewBXWY1DcK/Y3QUcEEF5mCmltzNk/1NsIfBmixRyrXlekSxqbKvm97MrAe9FSWVJibVIRWi7ePhnot9pDKHEhtqwWzqbiAQwz9Z179CHlx5Z7cTIWHdpdUI/wmPy2VZTvF5OYrk1eRh8MPoaUDIhdwCvt3OnFzug0hmrWvQ4/r5sx8DnBLL6sIuU490MF8wzQRZRK6pjjwzejBR/11aY+RreucFbnWgofa4hRA5gMdej5BVDmVTrokc1cF4u55G2PQUVkD82smz8drUpmFMXLLum9dHZXl7OVlnflaWJI7bwVkaokcEEfORbu8ZseKIg9wEVp6MMeHcnuGoCtCc+gHYxx0+I1nMUdN02uWqOMcog/0rX9C2kNkXaHd0rWbq9V2b97HQP0zr36IrNshd4wltIJdGOPij+TrmMXW7fAoU7OZ247uPPt7qGWGXbfDwlF5bdMVjQ1PST5omS1h7bV2HgR1bN55VL5vtGzV69mXDqxD33wb1wA9Ke2PEd4O7SxTPKxfrcjzsBl6HR5dt0P+KxtO+eDGTBiR0FHB63bICwgzhaBK8K7bb/uvS/uP/FXkF9z0lod0/+YPAAAAAElFTkSuQmCC", 
                "quantity": 40.0, 
                "route_id": 1
            }
        ]
    }
    EOM

    def index
      @packages = apply_scopes(current_user.packages(request)).order(ordering_params(params)).all
      json_response(@packages)
    end

    # GET /packages/:id
    def show
      if @tracer
        json_response(@package)
      else
        json_response({:message => "Couldn't find Package with id #{params[:id]}"}, :not_found)
      end
    end

    # POST /packages
    def create
      @package = Package.create!(package_params, request)
      json_response(@package, :created)
    end

    # PUT /packages/:id
    def update
      @package.update(package_params)
      head :no_content
    end

    # DELETE /packages/:id
    def destroy
      @packages = Package.where(parent_id: @package.id)
      @packages.each do |pack|
        pack.destroy
      end
      @tracer.show = false
      @package.save!
      head :no_content
    end

    private

    def package_params
      params.permit(:crop_id, :route_id, :quantity)
    end

    def set_package
      @package = current_user.packages(request).find(params[:id])
    end
  end
end