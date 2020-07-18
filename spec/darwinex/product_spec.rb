# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Darwinex::Product do
  subject(:product) { described_class.new(product_name: product_name, info_api: info_api) }

  let(:product_name) { 'DWC.4.20' }
  let(:info_api) { instance_double('Darwinex::Api::InfoApi') }

  let(:response) { { response: 'response' } }

  describe '#candles' do
    let(:resolution) { '1m' }
    let(:from) { 1_595_101_548 }
    let(:to) { 1_595_101_542 }

    before do
      expect(info_api).to receive(:get_candles).with(product_name, resolution: resolution, from: from, to: to).and_return(response)
    end

    it { expect(product.candles(resolution: resolution, from: from, to: to)).to eq(response) }
  end

  describe '#dxscore' do
    before do
      expect(info_api).to receive(:get_dxscore).with(product_name).and_return(response)
    end

    it { expect(product.dxscore).to eq(response) }
  end

  describe '#badges' do
    before do
      expect(info_api).to receive(:get_badges).with(product_name).and_return(response)
    end

    it { expect(product.badges).to eq(response) }
  end

  describe '#close_strategy' do
    before do
      expect(info_api).to receive(:get_close_strategy).with(product_name).and_return(response)
    end

    it { expect(product.close_strategy).to eq(response) }
  end

  describe '#duration_consistency' do
    before do
      expect(info_api).to receive(:get_duration_consistency).with(product_name).and_return(response)
    end

    it { expect(product.duration_consistency).to eq(response) }
  end

  describe '#experience' do
    before do
      expect(info_api).to receive(:get_experience).with(product_name).and_return(response)
    end

    it { expect(product.experience).to eq(response) }
  end

  describe '#losing_consistency' do
    before do
      expect(info_api).to receive(:get_losing_consistency).with(product_name).and_return(response)
    end

    it { expect(product.losing_consistency).to eq(response) }
  end

  describe '#market_correlation' do
    before do
      expect(info_api).to receive(:get_market_correlation).with(product_name).and_return(response)
    end

    it { expect(product.market_correlation).to eq(response) }
  end

  describe '#performance' do
    before do
      expect(info_api).to receive(:get_performance).with(product_name).and_return(response)
    end

    it { expect(product.performance).to eq(response) }
  end

  describe '#open_strategy' do
    before do
      expect(info_api).to receive(:get_open_strategy).with(product_name).and_return(response)
    end

    it { expect(product.open_strategy).to eq(response) }
  end

  describe '#capacity' do
    before do
      expect(info_api).to receive(:get_capacity).with(product_name).and_return(response)
    end

    it { expect(product.capacity).to eq(response) }
  end

  describe '#quotes' do
    before do
      expect(info_api).to receive(:get_quotes).with(product_name, from: from, to: to).and_return(response)
    end

    context 'when from and to set' do
      let(:from) { 1_595_101_548 }
      let(:to) { 1_595_101_542 }

      it { expect(product.quotes(from: from, to: to)).to eq(response) }
    end

    context 'when from and to not set' do
      let(:from) { nil }
      let(:to) { nil }

      it { expect(product.quotes).to eq(response) }
    end
  end

  describe '#risk_adjustment' do
    before do
      expect(info_api).to receive(:get_risk_adjustment).with(product_name).and_return(response)
    end

    it { expect(product.risk_adjustment).to eq(response) }
  end

  describe '#risk_stability' do
    before do
      expect(info_api).to receive(:get_risk_stability).with(product_name).and_return(response)
    end

    it { expect(product.risk_stability).to eq(response) }
  end

  describe '#winning_consistency' do
    before do
      expect(info_api).to receive(:get_winning_consistency).with(product_name).and_return(response)
    end

    it { expect(product.winning_consistency).to eq(response) }
  end

  describe '#order_divergence' do
    before do
      expect(info_api).to receive(:get_order_divergence).with(product_name).and_return(response)
    end

    it { expect(product.order_divergence).to eq(response) }
  end

  describe '#return_divergence' do
    before do
      expect(info_api).to receive(:get_return_divergence).with(product_name).and_return(response)
    end

    it { expect(product.return_divergence).to eq(response) }
  end

  describe '#monthly_divergence' do
    before do
      expect(info_api).to receive(:get_monthly_divergence).with(product_name).and_return(response)
    end

    it { expect(product.monthly_divergence).to eq(response) }
  end

  describe '#status' do
    before do
      expect(info_api).to receive(:get_product_status).with(product_name).and_return(response)
    end

    it { expect(product.status).to eq(response) }
  end

  describe '#scores' do
    context "when badge isn't set" do
      before do
        expect(info_api).to receive(:get_product_scores).with(product_name).and_return(response)
      end

      it { expect(product.scores).to eq(response) }
    end

    context 'when badge is set' do
      let(:badge) { 'EXPERIENCE' }

      before do
        expect(info_api).to receive(:get_product_scores_badge).with(product_name, badge).and_return(response)
      end

      it { expect(product.scores(badge: badge)).to eq(response) }
    end
  end
end
