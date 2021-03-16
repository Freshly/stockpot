# frozen_string_literal: true

require "rails_helper"

RSpec.describe Stockpot::RecordsController, type: :request do
  let(:json_headers) { { "CONTENT_TYPE": "application/json" }}
  let(:user) { FactoryBot.create(:user) }

  describe "POST #records" do
    it "requires a factory be specified to create" do
      expected = {
        status: 400,
        backtrace: "No backtrace",
        message: "You need to provide at least one factory name as an argument",
      }

      post records_path, params: {}.to_json, headers: json_headers
      check_error_response(response, expected)
    end

    it "calls a factory and return records" do
      first_name = "firstName1"
      last_name = "lastName1"
      params = {
        factories: [
          {
            factory: "user",
            attributes: [
              {
                first_name: first_name,
                last_name: last_name,
              }
            ]
          }
        ]
      }

      post records_path, params: params.to_json, headers: json_headers
      expect(response.status).to eql 202
      expect(User.last.first_name).to eql(first_name)
      expect(json_body["users"][0]["first_name"]).to eq(first_name)
      expect(json_body["users"][0]["last_name"]).to eq(last_name)
    end
    it "creates several records when the param list is passed in" do
      first_name_1 = "firstName1"
      last_name_1 = "lastName1"
      first_name_2 = "firstName2"
      last_name_2 = "lastName2"
      params = {
        factories: [
          {
            list: 2,
            factory: "user",
            attributes: [
              {
                first_name: first_name_1,
                last_name: last_name_1,
              },
              {
                first_name: first_name_2,
                last_name: last_name_2,
              },
            ]
          }
        ]
      }.to_json

      post records_path, params: params, headers: json_headers
      expect(response.status).to eql 202
      expect(User.all.count).to eql(2)
      expect(json_body["users"][0]["first_name"]).to eq(first_name_1)
      expect(json_body["users"][0]["last_name"]).to eq(last_name_1)
      expect(json_body["users"][1]["first_name"]).to eq(first_name_2)
      expect(json_body["users"][1]["last_name"]).to eq(last_name_2)
    end
    it "rollsback transactions if something goes wrong" do
      params = {
        factories: [
          {
            list: 2,
            factory: "user",
            attributes: [
              {
                first_name: "first_name_1",
                last_name: "last_name_1",
              },
              {
                non_existent_property: "none",
                last_name: "last_name_2",
              },
            ]
          }
        ]
      }.to_json

      post records_path, params: params, headers: json_headers
      expect(response.status).to eql 400
      expect(User.all.count).to eql(0)
    end
  end

  describe "GET #records" do
    it "requires a factory be specified to create" do
      expected = {
        status: 400,
        message: "You need to provide at least one model name as an argument",
        backtrace: "No backtrace",
      }

      get records_path, params: {}.to_json, headers: json_headers
      check_error_response(response, expected)
    end

    it"returns the correct record" do
      user
      params = {
        models: [
          {
            model: "user",
            id: user.id,
          }
        ]
      }

      get records_path, params: params, headers: json_headers
      expect(response.status).to eql 200
      expect(json_body["users"][0]["first_name"]).to eq(user.first_name)
      expect(json_body["users"][0]["last_name"]).to eq(user.last_name)
    end
  end

  describe "DELETE #records" do
    it "requires a factory be specified to create" do
      expected = {
        status: 400,
        message: "You need to provide at least one model name as an argument",
        backtrace: "No backtrace",
      }

      delete records_path, params: {}.to_json, headers: json_headers
      check_error_response(response, expected)
    end

    it "deletes the record specified" do
      user
      params = {
        models: [
          {
            model: "user",
            id: user.id,
          }
        ]
      }.to_json

      expect(User.last.id).to eql(user.id)
      delete records_path, params: params, headers: json_headers
      expect(User.all).to be_empty
    end
  end

  describe "PUT #records" do
    it "requires a factory be specified to create" do
      expected = {
        status: 400,
        message: "You need to provide at least one model name as an argument",
        backtrace: "No backtrace",
      }

      put records_path, params: {}.to_json, headers: json_headers

      check_error_response(response, expected)
    end

    it "updates the specified record" do
      user
      updated_first_name = "updated_first_name"
      params = {
        models: [
          {
            model: "user",
            id: user.id,
            update: { first_name: updated_first_name },
          }
        ]
       }.to_json

      expect(User.last.first_name).to eql(user.first_name)
      put records_path, params: params, headers: json_headers
      expect(User.last.first_name).to eq(updated_first_name)
    end
  end
end

## TODO
# Add more testing, scenarios...
# INDEX
# Returns several records if more than one records meets the filter criteria
# If the same record is requested more than once, only one is returned.
# If the same model is requested more than once, a merge of records should occur, so user will not return twice in different objects.
# If model has a namespace then the :: will be trimmed and finds the right model to query
# CREATE
# If the same model is requested more than once, a merge of records should occur, so user will not return twice in different objects.
# DESTROY
# Check rollbacks
# Even if the delete is triggered on the same model twice only one array is returned.
# Can delete several records
# UPDATE
# Same as destroy action
