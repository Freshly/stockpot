# frozen_string_literal: true

Stockpot::Engine.routes.draw do
  get "/records", to: "records#index"
  post "/records", to: "records#create"
  delete "/records", to: "records#destroy"
  put "/records", to: "records#update"

  delete "/clean_database", to: "database_cleaner#index"

  post "/redis", to: "redis#create"
  get "/redis", to: "redis#index"
  get "/redis/keys", to: "redis#keys"

  get "/healthz", to: "healthz#index"
end
