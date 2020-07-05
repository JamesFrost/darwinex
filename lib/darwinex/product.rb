module Darwinex
  class Product
    def initialize(product_name:, info_api:)
      @product_name = product_name
      @info_api = info_api
    end

    def status
      info_api.get_product_status(product_name)
    end

    def scores
      info_api.get_product_scores(product_name)
    end

    private

    attr_reader :product_name, :info_api
  end
end
