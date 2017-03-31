class Api::V1::PackagesController < ApplicationController
  before_action :set_package, only: [:show, :update, :destroy]

  # GET /packages
  def index
    @packages = Package.where(show: true)
    json_response(@packages)
  end

  # GET /packages/:id
  def show
    json_response(@package)
  end

  # POST /packages
  def create
    @package = Package.create!(package_params)
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
    @package.show = false
    @package.save!
    head :no_content
  end

  private

  def package_params
    params.permit(:parent_id, :crop_id, :route_id, :quantity)
  end

  def set_package
    @package = Package.where(show: true).find(params[:id])
  end
end
