# frozen_string_literal: true

require_dependency "stockpot/application_controller"
require_relative "../../../lib/stockpot/errors"

require "factory_bot_rails"

module Stockpot
  class RecordsController < ApplicationController
    include ActiveSupport::Inflector

    before_action only: %i[index destroy update] do
      Errors.return_error("You need to provide at least one model name as an argument", 400) if params.dig(:models).blank?
    end
    before_action only: %i[create] do
      Errors.return_error("You need to provide at least one factory name as an argument", 400) if params.dig(:factory).blank?
    end

    def index
      obj = {}
      models.each_with_index do |element, i|
        model = element[:model].to_s

        obj[pluralize(model).camelize(:lower)] = model.camelize.constantize.where(models[i].except(:model))
      end

      render json: obj, status: :ok
    rescue StandardError => exception
      render Errors.rescue_error(exception)
    end

    def create
      list = params[:list] || 1
      list.times do |n|
        all_parameters = [ factory, *traits, attributes(n) ].compact
        FactoryBot.create!(*all_parameters)
      end
      obj = factory.to_s.camelize.constantize.last(list)

      render json: obj, status: :created
    rescue StandardError => exception
      render Errors.rescue_error(exception)
    end

    def destroy
      obj = {}
      models.each_with_index do |element, i|
        model = element[:model].to_s
        obj[pluralize(model).camelize(:lower)] = model.camelize.constantize.where(models[i].except(:model)).destroy_all
      end

      render json: obj, status: :accepted
    rescue StandardError => exception
      render Errors.rescue_error(exception)
    end

    def update
      obj = {}
      models.each_with_index do |element, i|
        model = element[:model].to_s
        update_params = params.permit![:models][i][:update].to_h
        obj[pluralize(model).camelize(:lower)] = model.camelize.constantize.where(models[i].except(:model, :update)).update(update_params)
      end

      render json: obj, status: :accepted
    rescue StandardError => exception
      render Errors.rescue_error(exception)
    end

    private

    def traits
      return if params[:traits].blank?

      params[:traits].map(&:to_sym)
    end

    def factory
      params[:factory].to_sym
    end

    # rubocop:disable Naming/UncommunicativeMethodParamName
    def attributes(n)
      # rubocop:enable Naming/UncommunicativeMethodParamName
      return if params[:attributes].blank?

      params.permit![:attributes][n].to_h
    end

    def models
      params.permit![:models].map(&:to_h)
    end
  end
end
