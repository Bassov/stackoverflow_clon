# encoding: utf-8
# frozen_string_literal: true

require "allure-rspec"
require "simplecov"
require "capybara-webkit"

SimpleCov.start "rails"

Capybara::Webkit.configure do |config|
  config.allow_url("0.0.0.0")
end

RSpec.configure do |config|
  config.include AllureRSpec::Adaptor

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
