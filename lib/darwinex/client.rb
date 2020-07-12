# frozen_string_literal: true

require_relative 'api/investor_account_info_api'
require_relative 'api/trading_api'
require_relative 'api/token_api'
require_relative 'api/info_api'
require_relative 'investor_account'
require_relative 'product'
require_relative 'config'

module Darwinex
  class Client
    def initialize(consumer_key:, consumer_secret:, trading_api_version: nil, investor_account_info_api_version: nil, info_api_version: nil)
      @consumer_key = consumer_key
      @consumer_secret = consumer_secret
      @trading_api_version = trading_api_version
      @investor_account_info_api_version = investor_account_info_api_version
    end

    def refresh_access_token(refresh_token)
      config.refresh_access_token(refresh_token)
    end

    def list_investor_accounts
      investor_account_info_api.list_investor_accounts.map do |investor_account|
        InvestorAccount.new(
          account_id: investor_account['id'],
          trading_api: trading_api,
          investor_account_info_api: investor_account_info_api
        )
      end
    end

    def investor_account(account_id)
      InvestorAccount.new(
        account_id: account_id,
        trading_api: trading_api,
        investor_account_info_api: investor_account_info_api
      )
    end

    def list_products(status: nil, page: nil, per_page: nil)
      args = {
        status: status,
        page: page,
        per_page: per_page
      }

      api_response = info_api.list_products(args)

      products = api_response['content'].map do |product|
        Product.new(
          product_name: product['productName'],
          info_api: info_api
        )
      end

      response = api_response.tap { |h| h.delete('content') }

      response['products'] = products

      response
    end

    def product(product_name)
      Product.new(
        product_name: product_name,
        info_api: info_api
      )
    end

    private

    attr_reader :consumer_key, :consumer_secret, :trading_api_version, :investor_account_info_api_version, :info_api_version

    def investor_account_info_api
      @investor_account_info_api ||= Api::InvestorAccountInfoApi.new(config: config, version: investor_account_info_api_version)
    end

    def trading_api
      @trading_api ||= Api::TradingApi.new(config: config, version: trading_api_version)
    end

    def config
      @config ||= Config.new(
        token_api: token_api,
        consumer_key: consumer_key,
        consumer_secret: consumer_secret
      )
    end

    def token_api
      @token_api ||= Api::TokenApi.new
    end

    def info_api
      @info_api ||= Api::InfoApi.new(config: config, version: info_api_version)
    end
  end
end
