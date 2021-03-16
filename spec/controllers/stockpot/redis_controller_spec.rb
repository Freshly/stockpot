# frozen_string_literal: true

RSpec.describe Stockpot::RedisController, type: :request do
  let(:body) { { status: 200  }.to_json }

  describe "GET #index" do
    it "returns the redis value" do
      REDIS.set("test", "test_value")
      get redis_path, params: { key: "test" }
      expect(response.body).to eq("test_value".to_json)
      expect(response.status).to eq(200)
    end
    it "returns the redis value with field" do
      REDIS.hset("myhash", "field", "test")
      get redis_path, params: { key: "myhash", field: "field" }
      expect(response.body).to eq("test".to_json)
      expect(response.status).to eq(200)
    end
  end
  describe "POST #create" do
    it "creates a redis hash" do
      post redis_path, params: { key: "test", value: "test_value" }
      expect(REDIS.get("test")).to eq("test_value")
      expect(response.status).to eq(200)
    end
    it "creates a redis hash with field" do
      post redis_path, params: { key: "test", value: "test_value", field: "field" }
      expect(REDIS.hget("test", "field")).to eq("test_value")
      expect(response.status).to eq(200)
    end
  end
end
