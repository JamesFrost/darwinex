# frozen_string_literal: true

require 'httparty'

require_relative 'api'

# https://api.darwinex.com/store/apis/info?name=InvestorAccountInfoAPI&version=2.0&provider=admin#/account-info/findInfoUsingGET
module Darwinex::Api
  class InvestorAccountInfoApi < Api
    BASE_URI = 'https://api.darwinex.com/investoraccountinfo/'

    base_uri BASE_URI

    def initialize(config:, logger:, version: nil)
      super(logger)
      @config = config

      self.class.base_uri(BASE_URI + '/' + version) unless version.nil?
    end

    def list_investor_accounts
      send('get', '/investoraccounts', options)
    end

    def get_investor_account(account_id)
      send('get', "/investoraccounts/#{account_id}", options)
    end

    def list_conditional_orders(account_id, status, product_name: nil, page: nil, per_page: nil)
      query = {
        query: {
          productName: product_name,
          page: page,
          per_page: per_page
        }
      }

      send('get', "/investoraccounts/#{account_id}/conditionalorders/#{status}", options.merge(query))
    end

    def get_conditional_order(account_id, conditional_order_id)
      send('get', "/investoraccounts/#{account_id}/conditionalorders/conditional_order_id", options)
    end

    def get_current_positions(account_id, product_name: nil)
      query = {
        query: {
          productName: product_name
        }
      }

      send('get', "/investoraccounts/#{account_id}/currentpositions", options.merge(query))
    end

    def get_executed_orders(account_id, product_name: nil, page: nil, per_page: nil)
      query = {
        query: {
          productName: product_name,
          page: page,
          per_page: per_page
        }
      }

      send('get', "/investoraccounts/#{account_id}/orders/executed", options.merge(query))
    end

    def get_order(account_id, order_id)
      send('get', "/investoraccounts/#{account_id}/orders/#{order_id}", options)
    end

    def get_performance_fees(account_id, page: nil, per_page: nil)
      query = {
        query: {
          page: page,
          per_page: per_page
        }
      }

      send('get', "/investoraccounts/#{account_id}/performancefees", options.merge(query))
    end

    def get_performance_fees_for_product(account_id, product_name)
      send('get', "/investoraccounts/#{account_id}/performancefees/#{product_name}", options)
    end

    def list_trades(account_id, trade_status, product_name: nil, page: nil, per_page: nil)
      query = {
        query: {
          product_name: product_name,
          page: page,
          per_page: per_page
        }
      }

      send('get', "/investoraccounts/#{account_id}/trades/#{trade_status}", options.merge(query))
    end

    def get_trade(account_id, trade_id)
      send('get', "/investoraccounts/#{account_id}/trades/#{trade_id}", options)
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
