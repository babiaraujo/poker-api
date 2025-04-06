class CreateGameResults < ActiveRecord::Migration[7.1]
  def change
    create_table :game_results do |t|
      t.references :game, null: false, foreign_key: true
      t.string :winner_type
      t.integer :winner_id
      t.string :hand_type
      t.integer :pot

      t.timestamps
    end

    add_index :game_results, [ :winner_type, :winner_id ]
  end
end
