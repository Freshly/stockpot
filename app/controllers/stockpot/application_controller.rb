# frozen_string_literal: true
module Stockpot
  class ApplicationController < ActionController::API
    include ActiveSupport::Rescuable
    include Helper::Errors

    rescue_from StandardError do |exception|
      render rescue_error(exception)
    end
    # protect_from_forgery with: :exception
  end
end
