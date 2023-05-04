class BreweriesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @breweries = Brewery.all
  end

  def show
    @brewery = Brewery.find(params[:id])
  end

  def new

  end

  def create

  end
end
