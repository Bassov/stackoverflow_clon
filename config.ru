# encoding: utf-8
# frozen_string_literal: true

# This file is used by Rack-based servers to start the application.

require ::File.expand_path("../config/environment", __FILE__)
run Rails.application
