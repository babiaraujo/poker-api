class GameResult < ApplicationRecord
  belongs_to :game
  belongs_to :winner, polymorphic: true
end
