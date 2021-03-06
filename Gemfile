# frozen_string_literal: true

source "https://rubygems.org"
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "4.2.4"
# Use postgresql as the database for Active Record
gem "pg", "0.18.3"
# Use SCSS for stylesheets
gem "sass-rails", "~> 5.0"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"
# Use CoffeeScript for .coffee assets and views
gem "coffee-rails", "~> 4.1.0"
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem "jquery-rails"
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem "turbolinks"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.0"
# bundle exec rake doc:rails generates the API under doc/api.
gem "sdoc", "~> 0.4.0", group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
gem "slim-rails"
gem "therubyracer"
gem "less-rails"
gem "twitter-bootstrap-rails"
gem "bootstrap_form"

# Authorization and authentication gems
gem "devise"
gem "cancancan"
gem "omniauth"
gem "omniauth-facebook"
gem "omniauth-vk", git: "https://github.com/macrocoders/omniauth-vk.git"

# REST API gems
gem "doorkeeper"
gem "active_model_serializers"
gem "oj"
gem "oj_mimic_json"

# repeatable tasks and background jobs
gem "whenever"
gem "sidekiq"
gem "sidekiq-failures", git: "https://github.com/mhfs/sidekiq-failures.git"
gem "sinatra", require: false # for sidekiq web UI
gem "slim"

gem "carrierwave"
gem "remotipart"
gem "nested_form"
gem "private_pub"
gem "thin"
gem "skim"
gem "gon"
gem "responders"

gem "foreman"

gem "allure-rspec"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug"
  gem "rspec-rails"
  gem "rubocop-rspec"
  gem "rubocop", require: false
  gem "factory_girl_rails"
  gem "capybara"
  gem "launchy"
  gem "database_cleaner"
  gem "capybara-webkit"
  gem "pry"
  gem "letter_opener_web", "~> 1.0"
  gem "grape-swagger-rails"
end

group :test do
  gem "shoulda-matchers", require: false
  gem "json_spec"
  gem "simplecov", require: false
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem "web-console", "~> 2.0"

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
end
