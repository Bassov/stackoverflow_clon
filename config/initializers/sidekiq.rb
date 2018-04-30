# frozen_string_literal: true

require "sidekiq"

redis_options = StackoverflowClon::Application.config_for(:application)["redis"]
host = redis_options["host"]
port = redis_options["port"]
db   = redis_options["db"]

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{host}:#{port}/#{db}" }
end

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{host}:#{port}/#{db}" }
  config.failures_max_count = false
end

Sidekiq.default_worker_options = { "backtrace" => true }
ActiveJob::QueueAdapters::SidekiqAdapter::JobWrapper.sidekiq_options(retry: false)

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  options = Rails.application.config.application_options["sidekiq"] || { "login" => "jarvis", "password" => "Evwef2dsfWL!" }
  username == options["login"] && password == options["password"]
end
