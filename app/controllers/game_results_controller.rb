class GameResultsController < ApplicationController
  def index
    results = GameResult.includes(:winner, :game).all

    render json: results.as_json(
      include: {
        winner: { only: [ :id, :name ] },
        game: { only: [ :id, :phase ] }
      }
    )
  end

  def show
    result = GameResult.includes(:winner, :game).find(params[:id])

    render json: result.as_json(
      include: {
        winner: { only: [ :id, :name ] },
        game: { only: [ :id, :phase ] }
      }
    )
  end
end
