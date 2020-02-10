# frozen_string_literal: true

require "database_cleaner"

module Stockpot
  class DatabaseCleanerController < ApplicationController
    # Clean database before, between, and after tests by clearing Rails
    # and REDIS caches and truncating the active record database.
    def index
      clear_cache
      clean_active_record
      render json: { status: 204 }
    end

    private

    def clear_cache
      DatabaseCleaner[:redis].clean_with(:truncation)
      REDIS.flushdb
      Rails.cache.clear
      Timecop.return
    end

    def clean_active_record
      DatabaseCleaner[:active_record].clean_with(:truncation)
      DatabaseCleaner.clean_with(:truncation)
    end
  end
end
