# frozen_string_literal: true

require 'httparty'

require_relative 'api'

# https://api.darwinex.com/store/apis/info?name=DarwinTradingAPI&version=1.1&provider=admin#/
module Darwinex::Api
  class TradingApi < Api
    BASE_URI = 'https://api.darwinex.com/trading/1.1'

    base_uri BASE_URI

    def initialize(config:, logger:)
      super(logger)
      @config = config
    end

    def create_conditional_order(account_id, conditional_order_dto)
      body = {
        body: conditional_order_dto.to_json
      }

      send('post', "/investoraccounts/#{account_id}/conditionalorders", options.merge(body))
    end

    def update_conditional_order(account_id, conditional_order_id, conditional_order_dto)
      body = {
        body: conditional_order_dto.to_json
      }

      send('put', "/investoraccounts/#{account_id}/conditionalorders/#{conditional_order_id}", options.merge(body))
    end

    def delete_conditional_order(account_id, conditional_order_id)
      send('delete', "/investoraccounts/#{account_id}/conditionalorders/#{conditional_order_id}", options)
    end

    def get_leverage(account_id)
      send('get', "/investoraccounts/#{account_id}/leverage", options)
    end

    def update_leverage(account_id, leverage)
      body = {
        body: { leverage: leverage }.to_json
      }

      send('put', "/investoraccounts/#{account_id}/leverage", options.merge(body))
    end

    def create_buy_order(account_id, buy_order)
      body = {
        body: buy_order.to_json
      }

      send('post', "/investoraccounts/#{account_id}/orders/buy", options.merge(body))
    end

    def create_sell_order(account_id, sell_order)
      body = {
        body: sell_order.to_json
      }

      send('post', "/investoraccounts/#{account_id}/orders/sell", options.merge(body))
    end

    def create_stopout(account_id)
      send('post', "/investoraccounts/#{account_id}/stopout", options)
    end

    def create_product_stopout(account_id, product_name)
      send('post', "/investoraccounts/#{account_id}/stopout/#{product_name}", options)
    end

    def get_product_market_status
      send('get', '/productmarket/status', options)
    end

    private

    attr_reader :config

    def options
      {
        headers: {
          Authorization: "Bearer #{config.access_token}",
          'Content-Type' => 'application/json'
        }
      }
    end
  end
end
