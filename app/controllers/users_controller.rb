class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    respond_with(@user = current_user)
  end
end
