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
      param :parent_id, Integer, "Tells what's the parent package for this package if it does exist."
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

    api! 'Shows an specific package'
    description 'Retrieves a single package in the system.'
    formats ['json']
    error :code => 404, :desc => "Package with that id hasn't been found"
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM
    GET /v1/producer/packages/1 HTTP/1.1
    Accept: */*
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=79fb675bcf535b06c96ad2240e259684
    Connection: keep-alive
    
    
    
    HTTP/1.1 200 OK
    Cache-Control: max-age=0, private, must-revalidate
    Content-Type: application/json; charset=utf-8
    ETag: W/"b02f700f5ad975390b2df45422f8bbcf"
    Transfer-Encoding: chunked
    Vary: Origin
    X-Request-Id: 55fbc257-7a64-4b84-9b76-e3b44c1ead64
    X-Runtime: 10.503670
    
    {
        "data": {
            "crop_id": 1, 
            "id": 1, 
            "parent_id": null, 
            "qr_code": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAMgAAADIAQAAAACFI5MzAAADAElEQVR4nO1XQW6jQBDs8ViCG/mAgTwDCQxRXuQbSE4YEkvDLS+KFttIfoYZ/IFwAwnc2949O9LG2zllThYldbtmuqurZ3jtzODa+UG+FRFC2FAIBdO8BjCeb+gLQx4HUUGuRQIh1DtXNALxg4Mp0YEhw+qwCbJYHn0w4oZoX0QGlatttIbDGeWOMU9pZSLfF1YFHjFlyoM9pIVWUxIGa7H1XfCQI08nhHrTttTVQW92wuxQiDuGPKQ+/eWFYFoHCSx8ooPIUomqUCs1ZQkcKmhhMWtviXYVEZadrpx+XYcQRM/iOEPfdBx8+pUNgy1H+Z7AzvUMNuCw3JvTl1a/qbcJxFVrPG/pcfDBPi3zTmWPldxsnxdL+sJSb2BlVG9vKsiLtXyhGmhvinYVuRvUm12u5vJ9LUe8lHXjsSjsVeTD0Z1K30aQ+/fowZjj7NRw3GjXZfbg9LIQiawiH05n9Fk62FF5n0KRxIWY/3k3Fzj4eACkr8MYV2EYwmKJ/qlheTkS8rK0Xjf1QeuqbcUxYpn1ZtCOGrJ5QNI3PeDkn3bAwceBosuQBlMdJPIFWhfvkaWDHW1bmR7ri5AvW69xXcOhfB35lkwrOdKgnWZweaCY5d56KFMoC2uvqxCjKCLX9/Vo15E7GkyqhPxdRJF1/qt8HPXWWWQc+rRIwrgKZAMns/tm5XMGldIvOdZTAtF9g55/6er/31lgkb8dnh5Ra00VTxp/Q7RPEKSZVVrUWlMUPTRkLl3DcaMeWEQne90XicRfni+2980N//oq8gEFzWBYT4/7CuIz0HhkUfLOhnKl9ZM1whTNWlpzW+DwLk6foz0oPcxB6jMIgzxK8Wc7hDJLyPyH4G39llZEDj60HaZ5Zu334zQHEzfupX04vKVNHaSy+ZSQlHsNCt8YJqUoSQ+qcEqCWHj3aHgm0+WkOdEhW/6KjYtLlkn7CULL1MrJVFhvRYIzauAdi/JdtkNYKZC4r2pxbkVDmxvHVkDboaX1CBDG4xJcFwSPF/tB/h35DYy1goeVQE9qAAAAAElFTkSuQmCC", 
            "quantity": 40.0, 
            "route_id": 1
        }
    }
    EOM
    def show
      if @package
        json_response(@package)
      else
        json_response({:message => "Couldn't find Package with id #{params[:id]}"}, :not_found)
      end
    end

    api! 'Creates a new package'
    description 'Creates a new package having its crop id, route id, quantity and optionally the parent package id as parameters.'
    param_group :package
    error :code => 422, :desc => 'Unprocessable entity', :meta => {:problem => 'Missing multiple parameter'}
    example <<-EOM
    POST /v1/producer/packages/ HTTP/1.1
    Accept: application/json
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=79fb675bcf535b06c96ad2240e259684
    Connection: keep-alive
    Content-Length: 51
    Content-Type: application/json
    
    {
        "crop_id": "2", 
        "quantity": "40", 
        "route_id": "2"
    }
    
    HTTP/1.1 201 Created
    Cache-Control: max-age=0, private, must-revalidate
    Content-Type: application/json; charset=utf-8
    ETag: W/"d67a95a1f1e8dd6723361886f1fe5e0d"
    Transfer-Encoding: chunked
    Vary: Origin
    X-Request-Id: 41271d85-e1c4-4e1d-a938-b9e53d29a37f
    X-Runtime: 1.092293
    
    {
        "data": {
            "crop_id": 2, 
            "id": 3, 
            "parent_id": null, 
            "qr_code": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAMgAAADIAQAAAACFI5MzAAADBUlEQVR4nO1XQY6bQBDsNkjMDX8gwD7DEjZEfpFvIDkBb5Dg5hdZggVpn7GM/YHlNiMBnSbK1ZGyzuwpc4OSpmdququ7VnRvreDe+o98KoKIogJtN3HXxE1AK8l/DMRxiXItAKwComJH1oxE7yZuigKywc1hSjF+uXoAEh/Y7YNIdR50HBXW5Tu+BQbj6NyxN3YYhvDlqTcVhxQ4CrICrNP+GWQAPpmIMyDmUFWFVXdWga18IcS1gTisPuqgtD5O6Tbe+st1iEzwpvPKScmGqG31CmePMDBRWYMjkpM4jV0HIURvgbRmaaKy1sj3KenHOG1tePHkknCuCd4UHFSiv23j10tMT73nYW+Ct3dXnVPMyxq4fEDurtKPHjj1XcTV4iCcMrfGxu52LEieGd4GlZzzA2rcE40vt3aGWz98qvKtQQ8KEgg7aPb0tqPVl8BEHFc4rlsKfrnm2GAgn2bsTTAqlVYaS21zYYURycbqpTTC2xlLlVjtaBWvz1fP72VgQvlAcGEBV5bdHKeYVuRHRpTPVVUFjrDq6dhFtQco39BEJkpu9anIbO4Y4RSDd6UnMsHbGhx0lR4horLYsVR4V2ki34jbhTqV9mYbc8YxaysPTPC21uqUOyLdt5eYWdzyL//ju91HJJxVlXD5NPuL87woHwUmeFvTIA6YH5vssr/Et7a/frbyvWOeicT5QYU1Avk78GcjGu/CWTi5RnuD2+MOrkDBA7vdRwYnTxJwxo0NnfXs996N5woDcXwFp9TNy7alcfraw+8x9t+/D48UZ8XKl8ZWwXPYrX9kt/vIWpwF85YDTHaIsl/slAlFeldJJk5pvijf68ymh3rfxMy3uMOEr9NZbb2JiTMOG99EXrM75Hk5qzv+poCCxbeZqGB2h5Bk9ua4sbuWuC8Fvon7LOvkot7XPMMuloltoBG3yytTUPAgFNXcAFl2jHSMPyDsDrXIcggnXEYK9KPeBKO/3GFScV291iGbKeQZ6YFT30UWd8jil7EgRe2McubSMvVy/5G/RH4CBemIh7stKZ0AAAAASUVORK5CYII=", 
            "quantity": 40.0, 
            "route_id": 2
        }
    }
    EOM
    def create
      json_response(current_user.packages.create!(package_params, request), :created)
    end

    api! 'Updates an existing package'
    description 'Updates an existing package'
    param_group :package
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM
    PUT /v1/producer/packages/3 HTTP/1.1
    Accept: application/json
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=79fb675bcf535b06c96ad2240e259684
    Connection: keep-alive
    Content-Length: 18
    Content-Type: application/json
    
    {
        "quantity": "30"
    }
    
    HTTP/1.1 204 No Content
    Cache-Control: no-cache
    Vary: Origin
    X-Request-Id: 92e6ab4c-5f45-4ff1-afcf-9ce0067bfc85
    X-Runtime: 0.528860
    EOM
    def update
      @package.update(package_params)
      head :no_content
    end

    api! 'Deletes a package in the system'
    description 'Deletes a package in the system given an id. If this package has children associated, they will also be deleted. Use with discretion.'
    error :code => 401, :desc => 'No valid token authentication key has been provided.'
    see 'sessions#create', 'the sign-in endpoint'
    example <<-EOM
    DELETE /v1/producer/packages/2 HTTP/1.1
    Accept: */*
    Accept-Encoding: gzip, deflate
    Authorization:  Token token=79fb675bcf535b06c96ad2240e259684
    Connection: keep-alive
    Content-Length: 0
    
    
    
    HTTP/1.1 204 No Content
    Cache-Control: no-cache
    Vary: Origin
    X-Request-Id: d4110633-c94d-40b9-8a41-2f1f7a2f501b
    X-Runtime: 0.046969
    EOM
    def destroy
      @package.destroy
      head :no_content
    end

    private

    def package_params
      params.permit(:crop_id, :route_id, :parent_id, :quantity)
    end

    def set_package
      @package = current_user.packages(request).find(params[:id])
    end
  end
end