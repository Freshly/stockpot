# frozen_string_literal: true

require_dependency "stockpot/application_controller"

require "factory_bot_rails"

module Stockpot
  class RecordsController < ApplicationController
    include ActiveSupport::Inflector

    def index
      return_error("You need to provide at least one model name as an argument", 400) && return if params.dig(:models).blank?

      obj = {}
      models.each_with_index do |element, i|
        model = element[:model].to_s
        obj[pluralize(model).camelize(:lower)] = model.camelize.constantize.where(models[i].except(:model))
      end

      render json: obj, status: :ok
    end

    def create
      return_error("You need to provide at least one factory name as an argument", 400) && return if params.dig(:factory).blank?

      list = params[:list] || 1
      list.times do |n|
        if params[:traits].present? && params[:attributes].present?
          FactoryBot.create(factory, *traits, attributes[n])
        elsif params[:traits].blank? && params[:attributes].blank?
          # rubocop:disable Rails/SaveBang
          FactoryBot.create(factory)
          # rubocop:enable Rails/SaveBang
        elsif params[:attributes].blank?
          FactoryBot.create(factory, *traits)
        elsif params[:traits].blank?
          FactoryBot.create(factory, attributes[n])
        end
      end
      obj = factory.to_s.camelize.constantize.last(list)
      render json: obj, status: :created
    end

    def destroy
      return_error("You need to provide at least one model name as an argument", 400) && return if params.dig(:models).blank?

      obj = {}
      models.each_with_index do |element, i|
        model = element[:model].to_s
        obj[pluralize(model).camelize(:lower)] = model.camelize.constantize.where(models[i].except(:model)).destroy_all
      end

      render json: obj, status: :accepted
    end

    def update
      return_error("You need to provide at least one model name as an argument", 400) && return if params.dig(:models).blank?

      obj = {}
      models.each_with_index do |element, i|
        model = element[:model].to_s
        update_params = params.permit![:models][i][:update].to_h
        obj[pluralize(model).camelize(:lower)] = model.camelize.constantize.where(models[i].except(:model, :update)).update(update_params)
      end

      render json: obj, status: :accepted
    end

    private

    def return_error(message, status)
      render json: { "error": { "status": status, "message": message }}.to_json, status: status
    end

    def traits
      params[:traits].map(&:to_sym)
    end

    def factory
      params[:factory].to_sym
    end

    def attributes
      params.permit![:attributes].map(&:to_h)
    end

    def models
      params.permit![:models].map(&:to_h)
    end
  end
end
