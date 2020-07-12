# frozen_string_literal: true

require 'httparty'
require 'base64'

require_relative 'api'

module Darwinex::Api
  class TokenApi < Api
    BASE_URI = 'https://api.darwinex.com'

    base_uri BASE_URI

    def initialize(logger:)
      super(logger)
    end

    def refresh_access_token(refresh_token:, consumer_key:, consumer_secret:)
      auth_token = generate_auth_token(consumer_key, consumer_secret)

      options = {
        headers: {
          Authorization: "Basic #{auth_token}"
        }
      }

      body = {
        body: {
          grant_type: 'refresh_token',
          refresh_token: refresh_token
        }
      }

      send('post', '/token', options.merge(body))
    end

    private

    def generate_auth_token(consumer_key, consumer_secret)
      Base64.strict_encode64("#{consumer_key}:#{consumer_secret}")
    end
  end
end
