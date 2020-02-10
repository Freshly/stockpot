# frozen_string_literal: true
module Stockpot
  class HealthzController < ApplicationController
    def index
      render json: { "message": "success" }, status: :ok
    end
  end
end
