# frozen_string_literal: true

require_relative '../error'

module Darwinex::Api
  class InvalidCredentialsError < Darwinex::Error
    def initialize(msg, response)
      @response = response
      super(msg, response)
    end
  end
end
