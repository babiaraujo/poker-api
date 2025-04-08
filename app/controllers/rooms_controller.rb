class RoomsController < ApplicationController
  before_action :set_room, only: %i[ show update destroy ]

  def index
    @rooms = Room.all.includes(:players)
    render json: @rooms.as_json(include: { players: { only: [ :id, :name, :chips ] } })
  end

  def show
    render json: @room
  end

  def create
    @room = Room.new(room_params)

    if @room.save
      render json: @room, status: :created, location: @room
    else
      render json: @room.errors, status: :unprocessable_entity
    end
  end

  def update
    if @room.update(room_params)
      render json: @room
    else
      render json: @room.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @room.destroy!
  end

  def join
    room = Room.find(params[:id])

    if params[:player_id].blank?
      render json: { error: "dont found player id" }, status: :unprocessable_entity
      return
    end

    player = Player.find_by(id: params[:player_id])
    unless player
      render json: { error: "playr not found" }, status: :not_found
      return
    end

    if room.players.include?(player)
      render json: { message: "Player already in the room" }, status: :ok
    elsif room.players.count >= room.max_players
      render json: { message: "Room is full" }, status: :ok
    else
      room.players << player
      render json: { message: "Player joined successfully" }, status: :ok
    end
  end

  def leave
    room = Room.find(params[:id])
    player = Player.find(params[:player_id])

    if room.players.delete(player)
      render json: { message: "Player left successfully" }
    else
      render json: { message: "Player not found in room" }, status: :not_found
    end
  end

def start
  room = Room.find(params[:id])

  if room.players.count < 2
    render json: { message: "Not enough players to start a game" }, status: :unprocessable_entity
    return
  end

  game = GameInitializer.call(room)

  players_data = game.player_games.map do |pg|
    {
      id: pg.player.id,
      cards: pg.cards,
      chips: pg.player.chips
    }
  end

  render json: {
    message: "Game started",
    game_id: game.id,
    initial_state: {
      players: players_data,
      community_cards: game.community_cards,
      pot: game.pot,
      phase: game.phase
    }
  }
end


  private

  def set_room
    @room = Room.find(params[:id])
  end

  def room_params
    params.require(:room).permit(:name, :max_players)
  end
end
