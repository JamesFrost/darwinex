# frozen_string_literal: true

require_relative 'investor_account_info_api'
require_relative 'trading_api'
require_relative 'token_api'
require_relative 'info_api'
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

    def investor_account(account_id)
      InvestorAccount.new(
        account_id: account_id,
        trading_api: trading_api,
        investor_account_info_api: investor_account_info_api
      )
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
      @investor_account_info_api ||= InvestorAccountInfoApi.new(config: config, version: investor_account_info_api_version)
    end

    def trading_api
      @trading_api ||= TradingApi.new(config: config, version: trading_api_version)
    end

    def config
      @config ||= Config.new(
        token_api: token_api,
        consumer_key: consumer_key,
        consumer_secret: consumer_secret
      )
    end

    def token_api
      @token_api ||= TokenApi.new
    end

    def info_api
      @info_api ||= InfoApi.new(config: config, version: info_api_version)
    end
  end
end
