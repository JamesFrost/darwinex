# frozen_string_literal: true

require 'httparty'

require_relative 'api'

# https://api.darwinex.com/store/apis/info?name=DarwinInfoAPI&version=2.0&provider=admin#/
module Darwinex::Api
  class InfoApi < Api
    BASE_URI = 'https://api.darwinex.com/darwininfo/2.0'

    base_uri BASE_URI

    def initialize(config:, logger:)
      super(logger)
      @config = config
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

    def get_candles(product_name, resolution: nil, from:, to:)
      query = {
        query: {
          resolution: resolution,
          from: from,
          to: to
        }
      }

      send('get', "/products/#{product_name}/candles", options.merge(query))
    end

    def get_dxscore(product_name)
      send('get', "/products/#{product_name}/dxscore", options)
    end

    def get_badges(product_name)
      send('get', "/products/#{product_name}/history/badges", options)
    end

    def get_close_strategy(product_name)
      send('get', "/products/#{product_name}/history/closestrategy", options)
    end

    def get_duration_consistency(product_name)
      send('get', "/products/#{product_name}/history/durationconsistency", options)
    end

    def get_experience(product_name)
      send('get', "/products/#{product_name}/history/experience", options)
    end

    def get_losing_consistency(product_name)
      send('get', "/products/#{product_name}/history/losingconsistency", options)
    end

    def get_market_correlation(product_name)
      send('get', "/products/#{product_name}/history/marketcorrelation", options)
    end

    def get_performance(product_name)
      send('get', "/products/#{product_name}/history/performance", options)
    end

    def get_open_strategy(product_name)
      send('get', "/products/#{product_name}/history/openstrategy", options)
    end

    def get_capacity(product_name)
      send('get', "/products/#{product_name}/history/capacity", options)
    end

    def get_quotes(product_name, from: nil, to: nil)
      query = {
        query: {
          start: from,
          end: to
        }
      }

      send('get', "/products/#{product_name}/history/quotes", options.merge(query))
    end

    def get_risk_adjustment(product_name)
      send('get', "/products/#{product_name}/history/riskadjustment", options)
    end

    def get_risk_stability(product_name)
      send('get', "/products/#{product_name}/history/riskstability", options)
    end

    def get_winning_consistency(product_name)
      send('get', "/products/#{product_name}/history/winningconsistency", options)
    end

    def get_order_divergence(product_name)
      send('get', "/products/#{product_name}/history/orderdivergence", options)
    end

    def get_return_divergence(product_name)
      send('get', "/products/#{product_name}/history/returndivergence", options)
    end

    def get_monthly_divergence(product_name)
      send('get', "/products/#{product_name}/monthlydivergence", options)
    end

    def get_product_status(product_name)
      send('get', "/products/#{product_name}/status", options)
    end

    def get_product_scores(product_name)
      send('get', "/products/#{product_name}/scores", options)
    end

    def get_product_scores_badge(product_name, badge)
      send('get', "/products/#{product_name}/scores/#{badge}", options)
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
