# frozen_string_literal: true

RSpec.describe Stockpot::DatabaseCleanerController, type: :request do
  let(:body) { { status: 204  }.to_json }

  describe "DELETE #index" do
    it "truncates the database" do
      FactoryBot.create(:user)
      expect(User.all.count).to eq(1)
      delete clean_database_path
      expect(User.all.count).to eq(0)
      expect(response.body).to eq(body)
    end
    it "flushes REDIS" do
      REDIS.set("test", "test")
      expect(REDIS.keys).to_not be_empty
      delete clean_database_path
      expect(REDIS.keys).to be_empty
      expect(response.body).to eq(body)
    end
    it "restores the server time back to normal" do
      year = 1989

      Timecop.freeze(Time.local(year))
      expect(Time.now.year).to eq(year)
      delete clean_database_path
      expect(Time.now.year).to_not eq(year)
      expect(response.body).to eq(body)
    end
  end
end
