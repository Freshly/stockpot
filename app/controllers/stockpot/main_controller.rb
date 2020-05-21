# frozen_string_literal: true
module Stockpot
  class MainController < ActionController::API
    include ActiveSupport::Rescuable
    include Helper::Errors

    rescue_from Exception do |exception|
      rescue_error(exception)
    end
  end
end
