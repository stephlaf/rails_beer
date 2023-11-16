# frozen_string_literal: true

module Api
  module V1
    # Beers Controller
    class BeersController < Api::V1::BaseController
      PERMITTED_PARAMS = [
        :name,
        :upc,
        :category,
        :rating,
        :ibu,
        :alc_percent,
        :short_desc,
        :long_desc,
        :brewery_id,
        { photo: :file }
      ].freeze

      def all
        @beers = Beer.all.includes(:brewery).order_by_name
      end

      def search
        @beers = Beer.global_search(params[:query]).order_by_name
      end

      def show
        # raise
        @beer = Beer.find(params[:id])
      end

      def create
        @beer = Beer.new(beer_params)

        @beer.save!
        render :show
      end

      private

      def beer_params
        params.require(:beer).permit(PERMITTED_PARAMS)
      end
    end
  end
end
