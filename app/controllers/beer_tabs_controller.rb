# frozen_string_literal: true

class BeerTabsController < ApplicationController
  before_action :set_beer_tab, only: %i[edit update destroy]
  before_action :set_beer, only: %i[new create edit update]

  def index
    @beer_tabs = BeerTab.all
  end

  def show
    @beer_tab = BeerTab.find(params[:id])
  end

  def new
    # @beer = Beer.find(params[:beer_id])
    @beer_tab = BeerTab.new
  end

  def create
    # @beer = Beer.find(params[:beer_id])
    @user = current_user
    @beer_tab = BeerTab.new(beer_tab_params)

    @beer_tab.tried = true
    @beer_tab.user = current_user
    @beer_tab.beer = @beer

    if @beer_tab.save
      redirect_to beer_path(@beer)
    else
      render :new
    end
  end

  def edit; end

  def update
    @beer_tab.update(beer_tab_params)

    if @beer_tab.save
      redirect_to beer_path(@beer)
    else
      render :edit
    end
  end

  def destroy; end

  private

  def set_beer_tab
    @beer_tab = BeerTab.find(params[:id])
  end

  def set_beer
    @beer = Beer.find(params[:beer_id])
  end

  def beer_tab_params
    params.require(:beer_tab).permit(:rating, :content)
  end
end
