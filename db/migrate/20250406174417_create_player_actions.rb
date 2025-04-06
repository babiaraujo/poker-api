class CreatePlayerActions < ActiveRecord::Migration[8.0]
  def change
    create_table :player_actions do |t|
      t.references :player, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true
      t.string :action
      t.integer :amount
      t.string :phase

      t.timestamps
    end
  end
end
