class UsersController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def show
    respond_with(@user = current_user)
  end
end
