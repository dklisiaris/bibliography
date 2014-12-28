class PrizesController < ApplicationController
  before_action :set_prize, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @prizes = Prize.all.page(params[:page])
    respond_with(@prizes)
  end

  def show
    respond_with(@prize)
  end

  def new
    @prize = Prize.new
    respond_with(@prize)
  end

  def edit
  end

  def create
    @prize = Prize.new(prize_params)
    @prize.save
    respond_with(@prize)
  end

  def update
    @prize.update(prize_params)
    respond_with(@prize)
  end

  def destroy
    @prize.destroy
    respond_with(@prize)
  end

  private
    def set_prize
      @prize = Prize.find(params[:id])
    end

    def prize_params
      params.require(:prize).permit(:name)
    end
end
