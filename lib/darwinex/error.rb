# frozen_string_literal: true

module Darwinex
  class Error < StandardError
    def initialize(msg)
      super(msg)
    end
  end
end
