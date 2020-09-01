# frozen_string_literal: true

module Darwinex
  class Config
    attr_reader :access_token, :max_retries

    def initialize(token_api:, consumer_key:, consumer_secret:, max_retries:)
      @token_api = token_api
      @consumer_key = consumer_key
      @consumer_secret = consumer_secret
      @max_retries = max_retries
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
