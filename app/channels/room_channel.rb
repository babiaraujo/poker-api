class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_#{params[:room_id]}"
  end

  def receive(data)
    case data["type"]
    when "join"
      handle_join(data)
    when "player_action"
      handle_player_action(data)
    end
  end

  private

  def handle_join(data)
    player = RoomPlayer.find_or_create_by!(
      room_id: params[:room_id],
      player_id: data["playerId"]
    ) do |p|
      p.name = data["name"]
      p.chips = 1000
    end

    broadcast_game_state
  end

  def handle_player_action(data)
    broadcast_game_state
  end

  def broadcast_game_state
    room = Room.find(params[:room_id])
    players = room.room_players.map do |p|
      { playerId: p.player_id, name: p.name, chips: p.chips }
    end

    ActionCable.server.broadcast("room_#{params[:room_id]}", {
      type: "state",
      payload: {
        cards: [ "AH", "KH" ],
        communityCards: [ "QH", "JH", "KS" ],
        pot: 200,
        phase: "flop",
        players: players
      }
    })
  end
end
