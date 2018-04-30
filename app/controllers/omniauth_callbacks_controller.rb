# encoding: utf-8
# frozen_string_literal: true

class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :set_user

  def facebook
    sign_in_user("Facebook")
  end

  def vk
    sign_in_user("vk")
  end

  private

    def set_user
      @user = User.find_for_oauth(request.env["omniauth.auth"])
    end

    def sign_in_user(provider)
      if @user.try(:persisted?)
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
      else
        redirect_to :back, notice: "Could not authenticate you from #{provider}"
      end
    end
end
