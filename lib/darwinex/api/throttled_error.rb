# frozen_string_literal: true

require_relative 'error'

module Darwinex::Api
  class ThrottledError < Darwinex::Api::Error
    def initialize(msg, response)
      super(msg, response: response)
    end
  end
end
