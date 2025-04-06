class GameInitializer
    RANKS = %w[2 3 4 5 6 7 8 9 T J Q K A]
    SUITS = %w[H D C S] # Hearts, Diamonds, Clubs, Spades

    def self.call(room)
      deck = RANKS.product(SUITS).map { |r, s| "#{r}#{s}" }.shuffle

      game = Game.create!(
        room: room,
        pot: 0,
        phase: "pre_flop",
        community_cards: []
      )

      room.players.each do |player|
        hand = deck.shift(2)
        PlayerGame.create!(player: player, game: game, cards: hand)
      end

      game
    end
end
