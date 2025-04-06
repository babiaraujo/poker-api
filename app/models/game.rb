class Game < ApplicationRecord
  belongs_to :room
  has_many :player_games
  has_many :players, through: :player_games

  attribute :community_cards, :string, array: true, default: []
end
