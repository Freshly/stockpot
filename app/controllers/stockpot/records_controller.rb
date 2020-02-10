# frozen_string_literal: true
require "factory_bot_rails"

module Stockpot
  class RecordsController < ApplicationController
    include ActiveSupport::Inflector
    include ActiveRecord::Transactions

    before_action only: %i[index destroy update] do
      return_error("You need to provide at least one model name as an argument", 400) if params.dig(:models).blank?
    end
    before_action only: %i[create] do
      return_error("You need to provide at least one factory name as an argument", 400) if params.dig(:factory).blank?
    end

    def index
      obj = {}
      models.each_with_index do |element, i|
        model = element[:model].to_s
        class_name = find_correct_class_name(model)

        obj[pluralize(model).camelize(:lower)] = class_name.constantize.where(models[i].except(:model))
      end

      render json: obj, status: :ok
    end

    def create
      list = params[:list] || 1
      ActiveRecord::Base.transaction do
        list.times do |n|
          all_parameters = [ factory, *traits, attributes(n) ].compact
          @factory = FactoryBot.create(*all_parameters)
        end
      end
      obj = @factory.class.name.constantize.last(list)

      render json: obj, status: :created
    end

    def destroy
      obj = {}
      ActiveRecord::Base.transaction do
        models.each_with_index do |element, i|
          model = element[:model].to_s
          class_name = find_correct_class_name(model)
          obj[pluralize(model).camelize(:lower)] = class_name.constantize.where(models[i].except(:model)).destroy_all
        end
      end

      render json: obj, status: :accepted
    end

    def update
      obj = {}
      ActiveRecord::Base.transaction do
        models.each_with_index do |element, i|
          model = element[:model].to_s
          class_name = find_correct_class_name(model)
          update_params = params.permit![:models][i][:update].to_h
          obj[pluralize(model).camelize(:lower)] = class_name.constantize.where(models[i].except(:model, :update)).update(update_params)
        end
      end
      render json: obj, status: :accepted
    end

    private

    def find_correct_class_name(model)
      # We are getting the class name from the factory or we default to whatever we send in.
      # Something to keep in mind "module/class_name".camelize will translate into "Module::ClassName"
      # which is perfect for namespaces in case there is no factory associated with a specific model
      FactoryBot.factories.registered?(model) ? FactoryBot.build_stubbed(model).class.name : model.camelize
    end

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
