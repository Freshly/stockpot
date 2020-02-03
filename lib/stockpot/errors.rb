# frozen_string_literal: true

module Errors
  def self.rescue_error(error)
    logger = Logger.new(STDERR)
    logger.warn(error)

    case error
    when NameError
      return return_error(error.to_s, :bad_request)
    when PG::Error
      return return_error("Database error: #{error}", :server_error)
    else
      return return_error(error.to_s, :server_error)
    end
  end

  def self.return_error(message, status)
    return {json: { "error": { "status": status, "message": message }}, status: status}
  end
end
