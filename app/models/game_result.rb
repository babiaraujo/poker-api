# app/models/game_result.rb
class GameResult < ApplicationRecord
  belongs_to :game
  belongs_to :winner, polymorphic: true
end
