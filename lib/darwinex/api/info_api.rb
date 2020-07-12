# frozen_string_literal: true

require 'httparty'

require_relative 'api'

# https://api.darwinex.com/store/apis/info?name=DarwinInfoAPI&version=2.0&provider=admin#/
module Darwinex::Api
  class InfoApi < Api
    BASE_URI = 'https://api.darwinex.com/darwininfo/'

    base_uri BASE_URI

    def initialize(config:, version: nil)
      @config = config

      self.class.base_uri(BASE_URI + '/' + version) unless version.nil?
    end

    def list_products(status: nil, page: nil, per_page: nil)
      query = {
        query: {
          status: status,
          page: page,
          per_page: per_page
        }
      }

      send('get', '/products', options.merge(query))
    end

    def get_product_status(product_name)
      send('get', "/products/#{product_name}/status", options)
    end

    def get_product_scores(product_name)
      send('get', "/products/#{product_name}/scores", options)
    end

    private

    attr_reader :config

    def options
      {
        headers: {
          Authorization: "Bearer #{config.access_token}"
        }
      }
    end
  end
end
