require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class FreeAgent < OmniAuth::Strategies::OAuth2
      option :name, 'freeagent'

      option :client_options, {
        :site => 'https://api.freeagent.com',
        :authorize_url => '/v2/approve_app',
        :token_url => '/v2/token_endpoint'
      }

      uid do
        raw_info['user']['url'].split('/').last.to_i
      end

      info do
        {
          'email' => raw_info['user']['email'],
          'first_name' => raw_info['user']['first_name'],
          'last_name' => raw_info['user']['last_name'],
          'url' => raw_info['user']['url']
        }
      end

      extra do
        {
          "raw_info" => raw_info
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/v2/users/me').parsed.merge(access_token.get('/v2/company').parsed)
      end
    end
  end
end

OmniAuth.config.add_camelization 'freeagent', 'FreeAgent'
