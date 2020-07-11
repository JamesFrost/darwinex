# frozen_string_literal: true

require_relative 'invalid_credentials_error'
require_relative 'error'

module Darwinex::Api
  class Api
    include HTTParty

    MAX_RETRIES = 3

    def send(http_method, path, options, max_retries: MAX_RETRIES)
      response = backoff_and_retry(http_method, path, options, max_retries: max_retries)

      parse_response_for_errors(response)

      response.parsed_response
    end

    private

    def backoff_and_retry(http_method, path, options, max_retries:)
      retries = 0

      begin
        self.class.public_send(http_method, path, options)
      rescue Errno::ECONNREFUSED, Net::ReadTimeout => e
        if retries <= max_retries
          retries += 1
          sleep 2**retries
          retry
        else
          raise e
        end
      end
    end

    def parse_response_for_errors(response)
      unless response.success?
        body = response.parsed_response

        if body.dig('fault', 'message') == 'Invalid Credentials'
          msg = body['fault']['description']
          raise InvalidCredentialsError.new(msg, response)
        end

        # Darwinex need to be more consistent with their API responses :(
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
