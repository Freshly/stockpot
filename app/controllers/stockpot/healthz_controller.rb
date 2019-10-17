# frozen_string_literal: true

require_dependency "stockpot/application_controller"

module Stockpot
  class HealthzController < ApplicationController
    def index
      render json: { "message": "success" }, status: :ok
    end
  end
end
