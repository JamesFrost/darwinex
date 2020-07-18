# frozen_string_literal: true

require_relative 'error'

module Darwinex::Api
  class RefreshTokenExpiredError < Darwinex::Api::Error
    def initialize(msg, response)
      super(msg, response: response)
    end
  end
end
