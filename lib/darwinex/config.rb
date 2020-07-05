# frozen_string_literal: true

module Darwinex
  class Config
    attr_reader :access_token

    def initialize(token_api:, consumer_key:, consumer_secret:)
      @token_api = token_api
      @consumer_key = consumer_key
      @consumer_secret = consumer_secret
    end

    def refresh_access_token(refresh_token)
      tokens = token_api.refresh_access_token(refresh_token: refresh_token, consumer_key: consumer_key, consumer_secret: consumer_secret)

      @access_token = tokens['access_token']

      tokens
    end

    private

    attr_reader :token_api, :consumer_key, :consumer_secret
  end
end
