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

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.js { render status: :forbidden, alert: exception.message }
      format.json { render json: { errors: exception.message }, status: :forbidden }
      format.html { redirect_to root_url, alert: exception.message }
    end
  end
end
