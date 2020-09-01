# frozen_string_literal: true

module Darwinex
  class InvestorAccount
    attr_reader :account_id

    def initialize(account_id:, trading_api:, investor_account_info_api:)
      @account_id = account_id
      @trading_api = trading_api
      @investor_account_info_api = investor_account_info_api
    end

    def create_conditional_order(conditional_order_dto)
      trading_api.create_conditional_order(account_id, conditional_order_dto)
    end

    def update_conditional_order(conditional_order_id, conditional_order_dto)
      trading_api.update_conditional_order(account_id, conditional_order_id, conditional_order_dto)
    end

    def delete_conditional_order(conditional_order_id)
      trading_api.delete_conditional_order(account_id, conditional_order_id)
    end

    def leverage
      trading_api.get_leverage(account_id)
    end

    def update_leverage(leverage)
      trading_api.update_leverage(account_id, leverage)
    end

    def create_buy_order(buy_order)
      trading_api.create_buy_order(account_id, buy_order)
    end

    def create_sell_order(sell_order)
      trading_api.create_sell_order(account_id, sell_order)
    end

    def create_stopout(product_name = nil)
      if product_name.nil?
        trading_api.create_stopout(account_id)
      else
        trading_api.create_product_stopout(account_id, product_name)
      end
    end

    def summary
      investor_account_info_api.get_investor_account(account_id)
    end

    def conditional_orders(status, product_name: nil, page: nil, per_page: nil)
      investor_account_info_api.list_conditional_orders(
        account_id,
        status,
        product_name: product_name,
        page: page,
        per_page: per_page
      )
    end

    def current_positions(product_name: nil)
      investor_account_info_api.get_current_positions(account_id, product_name: product_name)
    end

    def executed_orders(product_name: nil, page: nil, per_page: nil)
      investor_account_info_api.get_executed_orders(
        account_id,
        product_name: product_name,
        page: page,
        per_page: per_page
      )
    end

    def order(order_id)
      investor_account_info_api.get_order(account_id, order_id)
    end

    def performance_fees(page: nil, per_page: nil)
      investor_account_info_api.get_performance_fees(account_id, page: page, per_page: per_page)
    end

    def product_performance_fees(product_name)
      investor_account_info_api.get_performance_fees_for_product(account_id, product_name)
    end

    def trades(trade_status, product_name: nil, page: nil, per_page: nil)
      investor_account_info_api.list_trades(account_id, trade_status, product_name: product_name, page: page, per_page: per_page)
    end

    def trade(trade_id)
      investor_account_info_api.get_trade(account_id, trade_id)
    end

    private

    attr_reader :trading_api, :investor_account_info_api
  end
end
