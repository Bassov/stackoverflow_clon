# encoding: utf-8
require 'application_responder'

# encoding: utf-8
# One day there would be comment about this controller
class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
