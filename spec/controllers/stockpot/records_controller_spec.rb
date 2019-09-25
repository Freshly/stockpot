# frozen_string_literal: true

require "rails_helper"

records_path = "/stockpot/records"
json_headers = { "CONTENT_TYPE": "application/json" }

RSpec.describe "Records requests", type: :request do
  describe "POST #records" do
    it "requires a factory be specified to create" do
      expected = { code: 400, message: "You need to provide at least one factory name as an argument" }

      post records_path, params: {}.to_json, headers: json_headers

      check_error_response(response, expected)
    end
  end

  describe "GET #records" do
    it "requires a factory be specified to create" do
      expected = { code: 400, message: "You need to provide at least one model name as an argument" }

      get records_path, params: {}.to_json, headers: json_headers

      check_error_response(response, expected)
    end
  end

  describe "DELETE #records" do
    it "requires a factory be specified to create" do
      expected = { code: 400, message: "You need to provide at least one model name as an argument" }

      delete records_path, params: {}.to_json, headers: json_headers

      check_error_response(response, expected)
    end
  end

  describe "PUT #records" do
    it "requires a factory be specified to create" do
      expected = { code: 400, message: "You need to provide at least one model name as an argument" }

      put records_path, params: {}.to_json, headers: json_headers

      check_error_response(response, expected)
    end
  end
end
