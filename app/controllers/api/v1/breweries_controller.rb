# frozen_string_literal: true

class Api::V1::BreweriesController < Api::V1::BaseController
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
