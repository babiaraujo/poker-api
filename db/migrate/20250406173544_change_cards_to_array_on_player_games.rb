class ChangeCardsToArrayOnPlayerGames < ActiveRecord::Migration[8.0]
  def change
    change_column :player_games, :cards, :string, array: true, default: [], using: "string_to_array(cards, ',')"
  end
end
