module Api::V1
  class TracersController < ApplicationController
    skip_before_action :require_login!, except: []

    
  end
end