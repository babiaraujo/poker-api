class GamesController < ApplicationController
  def next_phase
    game = Game.find(params[:id])

    if game.phase == "river"
      render json: { message: "Game is already at the final phase." }, status: :unprocessable_entity
      return
    end

    game = GameProgressor.call(game)

    render json: {
      message: "Game progressed to #{game.phase}",
      community_cards: game.community_cards
    }
  end

  # AGORA DENTRO DA CLASSE 👇
  def action
    game = Game.find(params[:id])
    player = Player.find(params[:player_id])
    action_type = params[:action_type]
    amount = params[:amount].to_i
    phase = game.phase

    unless %w[call raise fold].include?(action_type)
      render json: { error: "invalid action type" }, status: :unprocessable_entity
      return
    end

    PlayerAction.create!(
      player: player,
      game: game,
      action: action_type,
      amount: action_type == "fold" ? 0 : amount,
      phase: phase
    )

    if action_type == "raise" || action_type == "call"
      player.update!(chips: player.chips - amount)
      game.update!(pot: game.pot + amount)
    end

    render json: { message: "#{player.name} performed #{action_type} with amount #{amount}" }
  end

  def show
    game = Game.find(params[:id])

    render json: {
      game_id: game.id,
      phase: game.phase,
      pot: game.pot,
      community_cards: game.community_cards,
      players: game.players.select(:id, :name, :chips)
    }
  end

  def finish
    game = Game.find(params[:id])

    unless game.phase == "river"
      render json: { message: "game must be at river to finish" }, status: :unprocessable_entity
      return
    end

    players = game.player_games.includes(:player)

    evaluations = players.map do |pg|
      all_cards = pg.cards + game.community_cards
      hand = PokerHandEvaluator.evaluate(all_cards)

      {
        player_game: pg,
        player: pg.player,
        hand: hand
      }
    end

    winner = evaluations.max_by { |data| data[:hand][:rank] }

    if winner.nil?
      render json: { message: "No valid winner could be determined." }, status: :unprocessable_entity
      return
    end

    render json: {
      message: "game finished",
      winner: {
        id: winner[:player].id,
        name: winner[:player].name,
        hand: winner[:player_game].cards,
        hand_type: winner[:hand][:type]
      },
      pot: game.pot,
      community_cards: game.community_cards,
      players: players.map do |pg|
        {
          id: pg.player.id,
          name: pg.player.name,
          cards: pg.cards
        }
      end
    }
  end

  private

  def card_strength(rank)
    order = "23456789TJQKA"
    order.index(rank)
  end

  def card_letter(index)
    order = "23456789TJQKA"
    order[index]
  end
end
