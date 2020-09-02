# require 'pry-byebug'

class BeersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  
  def index
    if params[:query].present?
      @beers = Beer.includes(:brewery).global_search(params[:query])
      @url = params[:url]
    else
      @beers = Beer.includes(:brewery)
    end
    # raise
    # request.headers['HTTP_HOST']
  end

  def show
    @beer = Beer.find(params[:id])
    if current_user
      @beer_tab = BeerTab.where({ beer_id: @beer.id, user_id: current_user.id }).first
    end
  end
  
  def new
    @beer = Beer.new(upc: params[:upc])
  end

  # def new_upc
  #   @breweries = Brewery.all
  #   @beer = Beer.new(upc: params[:upc])
  # end

  # def create
  #   @brewery = Brewery.find_by(name: params[:beer][:brewery])

  #   if @brewery.nil?
  #     @brewery = Brewery.create!(name: params[:beer][:brewery])
  #   end

  #   params_hash = beer_params
  #   params_hash.delete(:brewery)

  #   @beer = Beer.new(params_hash)
  #   @beer.brewery = @brewery

  #   if @beer.save
  #     redirect_to root_path
  #   else
  #     render :new_upc
  #   end
  # end

  def edit
  end

  def update
  end

  def destroy
  end

  def scan
  end

  # POST /beers/get_barcode
  def get_barcode
    @upc = params[:upc]
    @beer = Beer.find_or_initialize_by(upc: @upc)
    render json: @beer
  end

  private

  def beer_params
    # params.require(:beer).permit(:name, :brewery, :alc_percent, :short_desc, :long_desc, :photo, :upc)
    params.require(:beer).permit(:name, :brewery, :photo, :upc)
  end
end



