class Api::V1::PackagesController < ApplicationController
  skip_before_action :require_login!, except: []
  before_action :set_package, only: [:show, :update, :destroy]

  has_scope :q, only: :index

  # GET /packages
  def index
    if @parentable && require_login!
      @packages = apply_scopes(@parentable.packages).order(ordering_params(params)).all
    else
      @packages = apply_scopes(Package).order(ordering_params(params)).all
    end
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
    params.permit(:parent_id, :crop_id, :route_id, :quantity)
  end

  def set_package
    @package = Package.find(params[:id])
  end
end
