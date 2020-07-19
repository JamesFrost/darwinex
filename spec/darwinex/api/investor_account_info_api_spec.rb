# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Darwinex::Api::InvestorAccountInfoApi do
  subject(:investor_account_info_api) { described_class.new(config: config, logger: logger) }

  let(:config) { instance_double('Darwinex::Config') }
  let(:logger) { Logger.new('/dev/null') }

  let(:access_token) { 'abc123' }

  let(:product_name) { 'DWC.4.20' }

  before do
    expect(config).to receive(:access_token).with(no_args).and_return(access_token)
  end

  describe '#list_investor_accounts', :vcr do
    let(:response) { investor_account_info_api.list_investor_accounts }

    it { expect(response).to be_an_instance_of(Array) }

    it { expect(response[0]).to have_key('id') }
    it { expect(response[0]['id']).to eq(1234) }

    it { expect(response[0]).to have_key('available') }
    it { expect(response[0]['available']).to eq(10_000.0) }
  end

  describe '#get_investor_account', :vcr do
    let(:account_id) { 1234 }

    let(:response) { investor_account_info_api.get_investor_account(account_id) }

    it { expect(response).to have_key('id') }
    it { expect(response['id']).to eq(account_id) }
  end

  xdescribe '#list_conditional_orders', :vcr do
  end

  xdescribe '#get_conditional_order', :vcr do
  end

  xdescribe '#get_current_positions', :vcr do
  end

  xdescribe '#get_executed_orders', :vcr do
  end

  xdescribe '#get_order', :vcr do
  end

  describe '#get_performance_fees', :vcr do
    let(:account_id) { 1234 }

    let(:response) { investor_account_info_api.get_performance_fees(account_id) }

    it { expect(response).to be_an_instance_of(Array) }
  end

  xdescribe '#get_performance_fees_for_product', :vcr do
  end

  xdescribe '#list_trades', :vcr do
  end

  xdescribe '#get_trade', :vcr do
  end
end
