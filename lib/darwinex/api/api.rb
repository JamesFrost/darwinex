# frozen_string_literal: true

require_relative 'refresh_token_expired_error'
require_relative 'invalid_credentials_error'
require_relative 'throttled_error'
require_relative 'error'

module Darwinex::Api
  class Api
    include HTTParty

    MAX_RETRIES = 5

    def initialize(logger)
      @logger = logger
    end

    def send(http_method, path, options, max_retries: MAX_RETRIES)
      response = backoff_and_retry(http_method, path, options, max_retries: max_retries)

      response.parsed_response
    end

    private

    attr_reader :logger

    def backoff_and_retry(http_method, path, options, max_retries:)
      retries = 0

      begin
        response = self.class.public_send(http_method, path, options)

        parse_response_for_errors(response)

        response
      rescue Errno::ECONNREFUSED, Net::ReadTimeout, ThrottledError => e
        if retries < max_retries
          retries += 1
          backoff_time = 2**retries

          logger.warn("#{e.message} - backing off for #{backoff_time} seconds")

          sleep backoff_time
          retry
        else
          raise e
        end
      end
    end

    def parse_response_for_errors(response)
      # Darwinex need to be more consistent with their API responses :(

      unless response.success?
        body = response.parsed_response

        if body['error'] == 'invalid_grant'
          msg = body['error_description']
          raise RefreshTokenExpiredError.new(msg, response)
        end

        if body.dig('fault', 'message') == 'Invalid Credentials'
          msg = body['fault']['description']
          raise InvalidCredentialsError.new(msg, response)
        end

        if body.dig('fault', 'message') == 'Message throttled out'
          msg = body['fault']['description']
          raise ThrottledError.new(msg, response)
        end

        if !body['status'].nil?
          msg = body['status']
        elsif !body['error_description'].nil?
          msg = body['error_description']
        elsif !body.dig('fault', 'description').nil?
          msg = body['fault']['description']
        end

        raise Error.new(msg, response: response)
      end
    end
  end
end
