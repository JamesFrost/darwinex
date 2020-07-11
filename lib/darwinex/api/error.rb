# frozen_string_literal: true

require_relative '../error'

module Darwinex::Api
  class Error < Darwinex::Error
    attr_reader :response

    def initialize(msg, response: nil)
      @response = response
      super(msg)
    end
  end
end
