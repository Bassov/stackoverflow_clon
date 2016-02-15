module OmniauthHelper
  def facebook_oauth
    OmniAuth.config.mock_auth[:facebook] =
        OmniAuth::AuthHash.new({
                                  'provider' => 'facebook',
                                  'uid' => '123545',
                                  'info' => {
                                    'email' => 'facebook@test.com',
                                  },
                                })
  end

  def vk_oauth
    OmniAuth.config.mock_auth[:vk] =
        OmniAuth::AuthHash.new({
                                   'provider' => 'vk',
                                   'uid' => '123545',
                                   'info' => {
                                       'email' => 'vk@test.com',
                                   },
                               })
  end
end
