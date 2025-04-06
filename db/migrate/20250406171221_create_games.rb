class CreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games do |t|
      t.references :room, null: false, foreign_key: true
      t.integer :pot
      t.string :phase
      t.text :community_cards

      t.timestamps
    end
  end
end
