# frozen_string_literal: true

module Darwinex
  class Error < StandardError
    attr_reader :response

    def initialize(msg, response: nil)
      @response = response
      super(msg)
    end
  end
end
