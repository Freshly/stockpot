# frozen_string_literal: true
require "factory_bot_rails"
require "active_record/persistence"

module Stockpot
  class RecordsController < MainController
    include ActiveSupport::Inflector
    include ActiveRecord::Transactions

    before_action only: %i[index destroy update] do
      return_error("You need to provide at least one model name as an argument", 400) if params.dig(:models).blank?
    end
    before_action only: %i[create] do
      return_error("You need to provide at least one factory name as an argument", 400) if params.dig(:factory).blank?
    end
    before_action do
      @obj = {}
    end

    def index
      models.each_with_index do |element, i|
        model = element[:model]
        class_name = find_correct_class_name(model)
        formatted_model = pluralize(model).camelize(:lower).gsub("::","")

        if @obj.has_key?(formatted_model)
          @obj[formatted_model].concat(class_name.constantize.where(models[i].except(:model)).to_a)
        else
          @obj[formatted_model] = class_name.constantize.where(models[i].except(:model)).to_a
        end  
      end

      render json: @obj, status: :ok
    end

    def create
      list = params[:list] || 1
      ids = []
      ActiveRecord::Base.transaction do
        list.times do |n|
          all_parameters = [ factory, *traits, attributes(n) ].compact
          
          @factory = FactoryBot.create(*all_parameters)
          ids << @factory.id
        end
      end
      @obj = @factory.class.name.constantize.where(id: ids)

      render json: @obj, status: :created
    end

    def destroy
      ActiveRecord::Base.transaction do
        models.each_with_index do |element, i|
          model = element[:model]
          class_name = find_correct_class_name(model)
          formatted_model = pluralize(model).camelize(:lower).gsub("::","")

          class_name.constantize.where(models[i].except(:model)).each do |record|
            record.destroy!
            @obj[formatted_model] = [] unless @obj.has_key?(formatted_model)
            @obj[formatted_model] << record
          end
        end
      end

      render json: @obj, status: :accepted
    end

    def update
      ActiveRecord::Base.transaction do
        models.each_with_index do |element, i|
          model = element[:model]
          class_name = find_correct_class_name(model)
          update_params = params.permit![:models][i][:update].to_h
          attributes_to_search = models[i].except(:model, :update)
          formatted_model = pluralize(model).camelize(:lower).gsub("::", "")

          class_name.constantize.where(attributes_to_search).each do |record|
            record.update!(update_params)
            @obj[formatted_model] = [] unless @obj.has_key?(formatted_model)
            @obj[formatted_model] << class_name.constantize.find(record.id)
          end
        end
      end
      render json: @obj, status: :accepted
    end

    private

    def find_correct_class_name(model)
      # We are getting the class name from the factory or we default to whatever we send in.
      # Something to keep in mind "module/class_name".camelize will translate into "Module::ClassName"
      # which is perfect for namespaces in case there is no factory associated with a specific model
      if FactoryBot.factories.registered?(model)
        FactoryBot.factories.find(model).build_class.to_s
      else
        model.camelize
      end  
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
