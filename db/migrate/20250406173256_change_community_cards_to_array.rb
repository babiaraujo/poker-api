class ChangeCommunityCardsToArray < ActiveRecord::Migration[8.0]
  def change
    change_column :games, :community_cards, :string, array: true, default: [], using: "string_to_array(community_cards, ',')"
  end
end
