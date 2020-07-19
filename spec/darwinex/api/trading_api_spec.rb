# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Darwinex::Api::TradingApi do
  subject(:info_api) { described_class.new(config: config, logger: logger) }

  let(:config) { instance_double('Darwinex::Config') }
  let(:logger) { Logger.new('/dev/null') }

  let(:access_token) { 'abc123' }

  let(:account_id) { '1234' }

  before do
    expect(config).to receive(:access_token).with(no_args).and_return(access_token)
  end

  xdescribe '#create_conditional_order', :vcr do
  end

  xdescribe '#update_conditional_order', :vcr do
  end

  xdescribe '#delete_conditional_order', :vcr do
  end

  describe '#get_leverage', :vcr do
    let(:response) { info_api.get_leverage(account_id) }

    it { expect(response).to have_key('leverage') }
    it { expect(response['leverage']).to eq(3.0) }
  end

  describe '#update_leverage', :vcr do
    let(:leverage) { 2.0 }

    let(:response) { info_api.update_leverage(account_id, leverage) }

    it { expect(response).to have_key('leverage') }
    it { expect(response['leverage']).to eq(2.0) }
  end

  xdescribe '#create_buy_order', :vcr do
  end

  xdescribe '#create_sell_order', :vcr do
  end

  xdescribe '#create_stopout', :vcr do
  end

  xdescribe '#create_product_stopout', :vcr do
  end

  describe '#get_product_market_status', :vcr do
    let(:response) { info_api.get_product_market_status }

    it { expect(response).to have_key('allowConditionalBuy') }
    it { expect(response['allowConditionalBuy']).to eq(true) }
  end
end
