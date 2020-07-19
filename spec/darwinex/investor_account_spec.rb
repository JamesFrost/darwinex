# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Darwinex::InvestorAccount do
  subject(:investor_account) { described_class.new(account_id: account_id, trading_api: trading_api, investor_account_info_api: investor_account_info_api) }

  let(:account_id) { '9001' }
  let(:trading_api) { instance_double('Darwinex::Api::TradingApi') }
  let(:investor_account_info_api) { instance_double('Darwinex::Api::InvestorAccountInfoApi') }

  let(:response) { { response: 'response' } }

  describe '#create_conditional_order' do
    let(:conditional_order_dto) do
      {
        'amount' => 215.15,
        'productName' => 'DWC.4.20',
        'quote' => 20.23,
        'side' => 'BUY',
        'type' => 'LESS_THAN_EQUAL',
        'thresholdParameters' => {
          'quoteStopLoss' => 10.05,
          'quoteTakeProfit' => 250.1
        }
      }
    end

    before do
      expect(trading_api).to receive(:create_conditional_order).with(account_id, conditional_order_dto).and_return(response)
    end

    it { expect(investor_account.create_conditional_order(conditional_order_dto)).to eq(response) }
  end

  describe '#update_conditional_order' do
    let(:conditional_order_id) { '1337' }

    let(:conditional_order_dto) do
      {
        'amount' => 215.15,
        'productName' => 'DWC.4.20',
        'quote' => 20.23,
        'side' => 'BUY',
        'type' => 'LESS_THAN_EQUAL',
        'thresholdParameters' => {
          'quoteStopLoss' => 10.05,
          'quoteTakeProfit' => 250.1
        }
      }
    end

    before do
      expect(trading_api).to receive(:update_conditional_order).with(account_id, conditional_order_id, conditional_order_dto).and_return(response)
    end

    it { expect(investor_account.update_conditional_order(conditional_order_id, conditional_order_dto)).to eq(response) }
  end

  describe '#delete_conditional_order' do
    let(:conditional_order_id) { '1337' }

    before do
      expect(trading_api).to receive(:delete_conditional_order).with(account_id, conditional_order_id).and_return(response)
    end

    it { expect(investor_account.delete_conditional_order(conditional_order_id)).to eq(response) }
  end

  describe '#leverage' do
    before do
      expect(trading_api).to receive(:get_leverage).with(account_id).and_return(response)
    end

    it { expect(investor_account.leverage).to eq(response) }
  end

  describe '#update_leverage' do
    let(:leverage) { 10 }

    before do
      expect(trading_api).to receive(:update_leverage).with(account_id, leverage).and_return(response)
    end

    it { expect(investor_account.update_leverage(leverage)).to eq(response) }
  end

  describe '#create_buy_order' do
    let(:buy_order) do
      {
        'amount' => 215.15,
        'productName' => 'DWC.4.20',
        'thresholdParameters' => {
          'quoteStopLoss' => 10.05,
          'quoteTakeProfit' => 250.1
        }
      }
    end

    before do
      expect(trading_api).to receive(:create_buy_order).with(account_id, buy_order).and_return(response)
    end

    it { expect(investor_account.create_buy_order(buy_order)).to eq(response) }
  end

  describe '#create_sell_order' do
    let(:sell_order) do
      {
        'amount' => 215.15,
        'productName' => 'DWC.4.20'
      }
    end

    before do
      expect(trading_api).to receive(:create_sell_order).with(account_id, sell_order).and_return(response)
    end

    it { expect(investor_account.create_sell_order(sell_order)).to eq(response) }
  end

  describe '#create_stopout' do
    context 'when a product name is set' do
      let(:product_name) { 'DWC.4.20' }

      before do
        expect(trading_api).to receive(:create_product_stopout).with(account_id, product_name).and_return(response)
      end

      it { expect(investor_account.create_stopout(product_name)).to eq(response) }
    end

    context 'when a product name is not set' do
      before do
        expect(trading_api).to receive(:create_stopout).with(account_id).and_return(response)
      end

      it { expect(investor_account.create_stopout).to eq(response) }
    end
  end

  describe '#summary' do
    before do
      expect(investor_account_info_api).to receive(:get_investor_account).with(account_id).and_return(response)
    end

    it { expect(investor_account.summary).to eq(response) }
  end

  describe '#conditional_orders' do
    let(:status) { 'pending' }

    context 'when optional args are set' do
      let(:product_name) { 'DWC.4.20' }
      let(:page) { 2 }
      let(:per_page) { 23 }

      before do
        expect(investor_account_info_api).to receive(:list_conditional_orders).with(account_id, status, product_name: product_name, page: page, per_page: per_page).and_return(response)
      end

      it { expect(investor_account.conditional_orders(status, product_name: product_name, page: page, per_page: per_page)).to eq(response) }
    end

    context 'when optional args are not set' do
      let(:product_name) { nil }
      let(:page) { nil }
      let(:per_page) { nil }

      before do
        expect(investor_account_info_api).to receive(:list_conditional_orders).with(account_id, status, product_name: product_name, page: page, per_page: per_page).and_return(response)
      end

      it { expect(investor_account.conditional_orders(status)).to eq(response) }
    end
  end

  describe '#current_positions' do
    context 'when a product name is set' do
      let(:product_name) { 'DWC.4.20' }

      before do
        expect(investor_account_info_api).to receive(:get_current_positions).with(account_id, product_name: product_name).and_return(response)
      end

      it { expect(investor_account.current_positions(product_name: product_name)).to eq(response) }
    end

    context 'when a product name is not set' do
      before do
        expect(investor_account_info_api).to receive(:get_current_positions).with(account_id, product_name: nil).and_return(response)
      end

      it { expect(investor_account.current_positions).to eq(response) }
    end
  end

  describe '#executed_orders' do
    context 'when optional args are set' do
      let(:product_name) { 'DWC.4.20' }
      let(:page) { 2 }
      let(:per_page) { 23 }

      before do
        expect(investor_account_info_api).to receive(:get_executed_orders).with(account_id, product_name: product_name, page: page, per_page: per_page).and_return(response)
      end

      it { expect(investor_account.executed_orders(product_name: product_name, page: page, per_page: per_page)).to eq(response) }
    end

    context 'when optional args are not set' do
      let(:product_name) { nil }
      let(:page) { nil }
      let(:per_page) { nil }

      before do
        expect(investor_account_info_api).to receive(:get_executed_orders).with(account_id, product_name: product_name, page: page, per_page: per_page).and_return(response)
      end

      it { expect(investor_account.executed_orders).to eq(response) }
    end
  end

  describe '#order' do
    let(:order_id) { 213 }

    before do
      expect(investor_account_info_api).to receive(:get_order).with(account_id, order_id).and_return(response)
    end

    it { expect(investor_account.order(order_id)).to eq(response) }
  end

  describe '#performance_fees' do
    context 'when optional args are set' do
      let(:page) { 2 }
      let(:per_page) { 28 }

      before do
        expect(investor_account_info_api).to receive(:get_performance_fees).with(account_id, page: page, per_page: per_page).and_return(response)
      end

      it { expect(investor_account.performance_fees(page: page, per_page: per_page)).to eq(response) }
    end

    context 'when optional args are not set' do
      let(:page) { nil }
      let(:per_page) { nil }

      before do
        expect(investor_account_info_api).to receive(:get_performance_fees).with(account_id, page: page, per_page: per_page).and_return(response)
      end

      it { expect(investor_account.performance_fees).to eq(response) }
    end
  end

  describe '#product_performance_fees' do
    let(:product_name) { 'DWC.4.20' }

    before do
      expect(investor_account_info_api).to receive(:get_performance_fees_for_product).with(account_id, product_name).and_return(response)
    end

    it { expect(investor_account.product_performance_fees(product_name)).to eq(response) }
  end

  describe '#trades' do
    let(:trade_status) { 'open' }

    context 'when optional args are set' do
      let(:product_name) { 'DWC.4.20' }
      let(:page) { 9 }
      let(:per_page) { 12 }

      before do
        expect(investor_account_info_api).to receive(:list_trades).with(account_id, trade_status, product_name: product_name, page: page, per_page: per_page).and_return(response)
      end

      it { expect(investor_account.trades(trade_status, product_name: product_name, page: page, per_page: per_page)).to eq(response) }
    end

    context 'when optional args are not set' do
      let(:product_name) { nil }
      let(:page) { nil }
      let(:per_page) { nil }

      before do
        expect(investor_account_info_api).to receive(:list_trades).with(account_id, trade_status, product_name: product_name, page: page, per_page: per_page).and_return(response)
      end

      it { expect(investor_account.trades(trade_status)).to eq(response) }
    end
  end

  describe '#trade' do
    let(:trade_id) { 123 }

    before do
      expect(investor_account_info_api).to receive(:get_trade).with(account_id, trade_id).and_return(response)
    end

    it { expect(investor_account.trade(trade_id)).to eq(response) }
  end
end
