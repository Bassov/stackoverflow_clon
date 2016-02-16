class UsersController < ApplicationController
  def show
    respond_with(@user = current_user)
  end
end
