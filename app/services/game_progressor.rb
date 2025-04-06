class GameProgressor
  PHASES = %w[pre_flop flop turn river].freeze

  def self.call(game)
    deck = generate_deck
    used_cards = game.community_cards + game.player_games.flat_map(&:cards)
    remaining_deck = deck - used_cards

    next_phase = PHASES[PHASES.index(game.phase) + 1]

    new_cards = case next_phase
    when "flop" then remaining_deck.shift(3)
    when "turn", "river" then remaining_deck.shift(1)
    else []
    end

    game.update!(
      phase: next_phase,
      community_cards: game.community_cards + new_cards
    )

    game
  end

  def self.generate_deck
    ranks = %w[2 3 4 5 6 7 8 9 T J Q K A]
    suits = %w[H D C S]
    ranks.product(suits).map { |r, s| "#{r}#{s}" }.shuffle
  end
end
