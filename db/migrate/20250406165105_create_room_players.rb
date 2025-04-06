class CreateRoomPlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :room_players do |t|
      t.references :room, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true

      t.timestamps
    end
  end
end
