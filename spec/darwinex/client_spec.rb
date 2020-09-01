# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Darwinex::Client do
  subject(:client) do
    described_class.new(
      consumer_key: consumer_key,
      consumer_secret: consumer_secret,
      max_retries: max_retries,
      logger: logger
    )
  end

  let(:consumer_key) { 'consumer_key' }
  let(:consumer_secret) { 'consumer_secret' }
  let(:max_retries) { 2 }
  let(:logger) { Logger.new('/dev/null') }

  let(:trading_api) { instance_double('Darwinex::Api::TradingApi') }
  let(:investor_account_info_api) { instance_double('Darwinex::Api::InvestorAccountInfoApi') }
  let(:token_api) { instance_double('Darwinex::Api::TokenApi') }
  let(:info_api) { instance_double('Darwinex::Api::InfoApi') }
  let(:config) { instance_double('Darwinex::Config') }

  before do
    allow(Darwinex::Api::TradingApi).to receive(:new).with(config: config, logger: logger).and_return(trading_api)
    allow(Darwinex::Api::InvestorAccountInfoApi).to receive(:new).with(config: config, logger: logger).and_return(investor_account_info_api)
    allow(Darwinex::Api::TokenApi).to receive(:new).with(max_retries: max_retries, logger: logger).and_return(token_api)
    allow(Darwinex::Api::InfoApi).to receive(:new).with(config: config, logger: logger).and_return(info_api)
    allow(Darwinex::Config).to receive(:new).with(token_api: token_api, consumer_key: consumer_key, consumer_secret: consumer_secret, max_retries: max_retries).and_return(config)
  end

  describe '#refresh_access_token' do
    let(:refresh_token) { 'refresh_token' }
    let(:tokens) do
      {
        'access_token' => 'access_token',
        'refresh_token' => 'new_refresh_token',
        'scope' => 'openid',
        'id_token' => 'a_long_string',
        'token_type' => 'Bearer',
        'expires_in' => 3600
      }
    end

    before do
      expect(config).to receive(:refresh_access_token).with(refresh_token).and_return(tokens)
    end

    it { expect(client.refresh_access_token(refresh_token)).to eq(tokens) }
  end

  xdescribe '#list_investor_accounts' do
  end

  describe '#investor_account' do
    let(:account_id) { 1234 }

    let(:investor_account) { instance_double('Darwinex::InvestorAccount') }

    let(:investor_account_args) do
      {
        account_id: account_id,
        trading_api: trading_api,
        investor_account_info_api: investor_account_info_api
      }
    end

    it 'creates a new investor account' do
      expect(Darwinex::InvestorAccount).to receive(:new).with(investor_account_args).and_return(investor_account)

      expect(client.investor_account(account_id)).to eq(investor_account)
    end
  end

  xdescribe '#list_products' do
  end

  describe '#product' do
    let(:product_name) { 'DWC.4.20' }

    let(:product) { instance_double('Darwinex::Product') }

    let(:product_args) do
      {
        product_name: product_name,
        info_api: info_api
      }
    end

    it 'creates a new product' do
      expect(Darwinex::Product).to receive(:new).with(product_args).and_return(product)

      expect(client.product(product_name)).to eq(product)
    end
  end
end
