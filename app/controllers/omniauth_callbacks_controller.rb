# encoding: utf-8
class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # before_action :set_user

  def facebook
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    sign_in_user('Facebook')
  end

  def vk
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    sign_in_user('vk')
  end

  private

  def set_user
    @user = User.find_for_oauth(request.env['omniauth.auth'])
  end

  def sign_in_user(provider)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    end
  end
end
