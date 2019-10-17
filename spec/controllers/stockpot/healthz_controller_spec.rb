# frozen_string_literal: true

require "rails_helper"

records_path = "/stockpot/healthz"
json_headers = { "CONTENT_TYPE": "application/json" }

RSpec.describe "Health requests", type: :request do
  describe "GET #healthz" do
    it "returns successfully if the route is available" do
      get records_path, params: {}.to_json, headers: json_headers

      expect(response.code).to eql "200"
    end
  end
end
