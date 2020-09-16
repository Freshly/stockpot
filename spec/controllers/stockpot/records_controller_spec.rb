# frozen_string_literal: true

require "rails_helper"

RSpec.describe Stockpot::RecordsController, type: :request do
  include Stockpot::Engine.routes.url_helpers
  let(:json_headers) { { "CONTENT_TYPE": "application/json" }}

  describe "POST #records", focus: true do
    it "requires a factory be specified to create" do
      post records_path, params: {}.to_json, headers: json_headers
      expected = {
        error: {
          status: 400,
          backtrace: "No backtrace",
          message: "You need to provide at least one factory name as an argument"
        }
      }.to_json
      expect(response.body).to eq(expected)
      expect(response.status).to eq(400)
    end

    it "calls a factory and return records" do
      current_time = Time.local(2008, 9, 1, 12, 0, 0)
      Timecop.freeze(current_time)
      first_name = "firstName1"
      last_name = "lastName1"
      expected = {
        users: [{
          id: 1,
          first_name: first_name,
          last_name: last_name,
          created_at: current_time.utc(),
          updated_at: current_time.utc(),
        }]
      }.to_json
      post records_path, params: {factories: [{ factory: "user", attributes: [{ first_name: first_name, last_name: last_name  }] }]}.to_json, headers: json_headers

      expect(response.body).to eq(expected)
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
