class PlayerGame < ApplicationRecord
  belongs_to :player
  belongs_to :game

  attribute :cards, :string, array: true, default: []
end
