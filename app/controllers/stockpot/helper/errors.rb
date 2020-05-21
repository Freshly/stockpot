# frozen_string_literal: true
module Stockpot
  module Helper
    module Errors
      def rescue_error(error)
        logger = Logger.new(STDERR)
        logger.warn(error)

        case error
        when NameError
          return_error(error.to_s, error.backtrace.first(5), :bad_request)
        when PG::Error
          return_error("Postgres error: #{error}", error.backtrace.first(5), :internal_server_error)
        when ActiveRecord::RecordInvalid, ActiveRecord::Validations, ActiveRecord::RecordNotDestroyed
          return_error("ActiveRecord error: #{error}", error.backtrace.first(5), :expectation_failed)
        else
          return_error(error.to_s, error.backtrace.first(5),:internal_server_error)
        end
      end

      def return_error(message, backtrace, status)
        render json: { error: { status: status, backtrace: backtrace, message: message }}, status: status
      end
    end
  end
end
