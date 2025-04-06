class RoomsController < ApplicationController
  before_action :set_room, only: %i[ show update destroy ]

  # GET /rooms
  def index
    @rooms = Room.all
    render json: @rooms
  end

  # GET /rooms/1
  def show
    render json: @room
  end

  # POST /rooms
  def create
    @room = Room.new(room_params)

    if @room.save
      render json: @room, status: :created, location: @room
    else
      render json: @room.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /rooms/1
  def update
    if @room.update(room_params)
      render json: @room
    else
      render json: @room.errors, status: :unprocessable_entity
    end
  end

  # DELETE /rooms/1
  def destroy
    @room.destroy!
  end

  # POST /rooms/:id/join
  def join
    room = Room.find(params[:id])
    player = Player.find(params[:player_id])

    if room.players.include?(player)
      render json: { message: "Player already in the room" }, status: :unprocessable_entity
    elsif room.players.count >= room.max_players
      render json: { message: "Room is full" }, status: :unprocessable_entity
    else
      room.players << player
      render json: { message: "Player joined successfully" }
    end
  end

  # POST /rooms/:id/leave
  def leave
    room = Room.find(params[:id])
    player = Player.find(params[:player_id])

    if room.players.delete(player)
      render json: { message: "Player left successfully" }
    else
      render json: { message: "Player not found in room" }, status: :not_found
    end
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end

  def room_params
    params.require(:room).permit(:name, :max_players)
  end
end
