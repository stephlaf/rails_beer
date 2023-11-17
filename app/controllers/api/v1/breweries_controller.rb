# frozen_string_literal: true

module Api
  module V1
    # BreweriesController
    class BreweriesController < Api::V1::BaseController
      def all
        @breweries = Brewery.all.order_by_name
      end

      def search
        @breweries = Brewery.global_search(params[:query]).order_by_name
      end

      def show
        @brewerie = Brewery.find(params[:id])
      end
    end
  end
end
