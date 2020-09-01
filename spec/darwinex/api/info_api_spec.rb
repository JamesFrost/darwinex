# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Darwinex::Api::InfoApi do
  subject(:info_api) { described_class.new(config: config, logger: logger) }

  let(:config) { instance_double('Darwinex::Config') }
  let(:max_retries) { 2 }
  let(:logger) { Logger.new('/dev/null') }

  let(:access_token) { 'abc123' }

  let(:product_name) { 'DWC.4.20' }

  before do
    expect(config).to receive(:access_token).with(no_args).and_return(access_token)
    expect(config).to receive(:max_retries).with(no_args).and_return(max_retries)
  end

  describe '#list_products', :vcr do
    context 'when optional args are not set' do
      let(:response) { info_api.list_products }

      it { expect(response).to have_key('content') }
      it { expect(response['first']).to eq(true) }
    end

    context 'when optional args are set' do
      let(:status) { 'ACTIVE' }
      let(:page) { 20 }
      let(:per_page) { 2 }

      let(:response) { info_api.list_products(status: status, page: page, per_page: per_page) }

      it { expect(response).to have_key('content') }
      it { expect(response['first']).to eq(false) }
      it { expect(response['pageable']['pageNumber']).to eq(page) }
      it { expect(response['pageable']['pageSize']).to eq(per_page) }
    end
  end

  describe '#get_candles', :vcr do
    let(:from) { 1_595_101_548 }
    let(:to) { 1_595_101_542 }

    context 'when optional args are not set' do
      let(:response) { info_api.get_candles(product_name, from: from, to: to) }

      it { expect(response['candles']).to be_an_instance_of(Array) }
    end

    context 'when optional args are set' do
      let(:resolution) { '1m' }

      let(:response) { info_api.get_candles(product_name, resolution: resolution, from: from, to: to) }

      it { expect(response['candles']).to be_an_instance_of(Array) }
    end
  end

  describe '#get_dxscore', :vcr do
    let(:response) { info_api.get_dxscore(product_name) }

    it { expect(response).to eq(55.15) }
  end

  describe '#get_badges', :vcr do
    let(:response) { info_api.get_badges(product_name) }

    it { expect(response).to be_an_instance_of(Array) }
  end

  describe '#get_close_strategy', :vcr do
    let(:response) { info_api.get_close_strategy(product_name) }

    it { expect(response).to be_an_instance_of(Array) }
  end

  describe '#get_duration_consistency', :vcr do
    let(:response) { info_api.get_duration_consistency(product_name) }

    it { expect(response).to be_an_instance_of(Array) }
  end

  describe '#get_experience', :vcr do
    let(:response) { info_api.get_experience(product_name) }

    it { expect(response).to be_an_instance_of(Array) }
  end

  describe '#get_losing_consistency', :vcr do
    let(:response) { info_api.get_losing_consistency(product_name) }

    it { expect(response).to be_an_instance_of(Array) }
  end

  describe '#get_market_correlation', :vcr do
    let(:response) { info_api.get_market_correlation(product_name) }

    it { expect(response).to be_an_instance_of(Array) }
  end

  describe '#get_performance', :vcr do
    let(:response) { info_api.get_performance(product_name) }

    it { expect(response).to be_an_instance_of(Array) }
  end

  describe '#get_open_strategy', :vcr do
    let(:response) { info_api.get_open_strategy(product_name) }

    it { expect(response).to be_an_instance_of(Array) }
  end

  describe '#get_capacity', :vcr do
    let(:response) { info_api.get_capacity(product_name) }

    it { expect(response).to be_an_instance_of(Array) }
  end

  describe '#get_quotes', :vcr do
    context 'when optional args are not set' do
      let(:response) { info_api.get_quotes(product_name) }

      it { expect(response).to be_an_instance_of(Array) }
    end

    context 'when optional args are set' do
      let(:from) { 1_595_101_548 }
      let(:to) { 1_595_101_542 }
      let(:response) { info_api.get_quotes(product_name, from: from, to: to) }

      it { expect(response).to be_an_instance_of(Array) }
    end
  end

  describe '#get_risk_adjustment', :vcr do
    let(:response) { info_api.get_risk_adjustment(product_name) }

    it { expect(response).to be_an_instance_of(Array) }
  end

  describe '#get_risk_stability', :vcr do
    let(:response) { info_api.get_risk_stability(product_name) }

    it { expect(response).to be_an_instance_of(Array) }
  end

  describe '#get_winning_consistency', :vcr do
    let(:response) { info_api.get_winning_consistency(product_name) }

    it { expect(response).to be_an_instance_of(Array) }
  end

  describe '#get_order_divergence', :vcr do
    let(:response) { info_api.get_order_divergence(product_name) }

    it { expect(response).to be_an_instance_of(Array) }
  end

  describe '#get_return_divergence', :vcr do
    let(:response) { info_api.get_return_divergence(product_name) }

    it { expect(response).to be_an_instance_of(Array) }
  end

  describe '#get_monthly_divergence', :vcr do
    let(:response) { info_api.get_monthly_divergence(product_name) }

    it { expect(response).to eq(0.0) }
  end

  describe '#get_product_status', :vcr do
    let(:response) { info_api.get_product_status(product_name) }

    it { expect(response['status']).to eq('ACTIVE') }
  end

  describe '#get_product_scores', :vcr do
    let(:response) { info_api.get_product_scores(product_name) }

    it { expect(response['score']).to eq(55.15) }
  end

  describe '#get_product_scores_badge', :vcr do
    let(:badge) { 'EXPERIENCE' }

    let(:response) { info_api.get_product_scores_badge(product_name, badge) }

    it { expect(response).to eq(10.0) }
  end
end
