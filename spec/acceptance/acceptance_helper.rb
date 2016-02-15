# encoding: utf-8
require 'rails_helper'

OmniAuth.config.test_mode = true

RSpec.configure do |config|
  Capybara.javascript_driver = :webkit

  config.include AcceptanceHelper, type: :feature
  config.include OmniauthHelper, type: :feature

  config.order = "random"

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
