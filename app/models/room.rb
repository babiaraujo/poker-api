class Room < ApplicationRecord
    has_many :room_players
    has_many :players, through: :room_players
  end
  