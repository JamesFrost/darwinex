# frozen_string_literal: true

require_relative 'invalid_credentials_error'
require_relative 'error'

module Darwinex::Api
  class Api
    include HTTParty

    def send(http_method, path, options)
      response = self.class.public_send(http_method, path, options)

      parse_response_for_errors(response)

      response.parsed_response
    end

    private

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
