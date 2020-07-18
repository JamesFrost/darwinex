# frozen_string_literal: true

module Darwinex
  class Product
    def initialize(product_name:, info_api:)
      @product_name = product_name
      @info_api = info_api
    end

    def candles(resolution: nil, from:, to:)
      info_api.get_candles(
        product_name,
        resolution: resolution,
        from: from,
        to: to
      )
    end

    def dxscore
      info_api.get_dxscore(product_name)
    end

    def badges
      info_api.get_badges(product_name)
    end

    def close_strategy
      info_api.get_close_strategy(product_name)
    end

    def duration_consistency
      info_api.get_duration_consistency(product_name)
    end

    def experience
      info_api.get_experience(product_name)
    end

    def losing_consistency
      info_api.get_losing_consistency(product_name)
    end

    def market_correlation
      info_api.get_market_correlation(product_name)
    end

    def performance
      info_api.get_performance(product_name)
    end

    def open_strategy
      info_api.get_open_strategy(product_name)
    end

    def capacity
      info_api.get_capacity(product_name)
    end

    def quotes(from: nil, to: nil)
      info_api.get_quotes(product_name, from: from, to: to)
    end

    def risk_adjustment
      info_api.get_risk_adjustment(product_name)
    end

    def risk_stability
      info_api.get_risk_stability(product_name)
    end

    def winning_consistency
      info_api.get_winning_consistency(product_name)
    end

    def order_divergence
      info_api.get_order_divergence(product_name)
    end

    def return_divergence
      info_api.get_return_divergence(product_name)
    end

    def monthly_divergence
      info_api.get_monthly_divergence(product_name)
    end

    def status
      info_api.get_product_status(product_name)
    end

    def scores(badge: nil)
      if badge.nil?
        info_api.get_product_scores(product_name)
      else
        info_api.get_product_scores_badge(product_name, badge)
      end
    end

    private

    attr_reader :product_name, :info_api
  end
end
