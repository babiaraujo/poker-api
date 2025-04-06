class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_#{params[:room_id]}"
  end

  def unsubscribed
    # Cleanup quando o cliente desconecta (se necessário)
  end
end
