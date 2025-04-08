class PlayersController < ApplicationController
  before_action :set_player, only: [ :show, :destroy ]

  def show
    render json: @player
  end

  def create
    @player = Player.new(player_params)

    if @player.save
      render json: @player, status: :created, location: @player
    else
      render json: @player.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @player.destroy!
  end

  private

  def set_player
    @player = Player.find(params[:id])
  end

  def player_params
    params.require(:player).permit(:name, :chips)
  end
end
