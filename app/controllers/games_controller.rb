class GamesController < ApplicationController
  PHASES = %w[pre_flop flop turn river]

  def next_phase
    game = Game.find(params[:id])

    current_index = PHASES.index(game.phase)
    if current_index.nil?
      render json: { error: "current phase invalid." }, status: :unprocessable_entity
      return
    end

    if current_index >= PHASES.size - 2
      render json: { message: "game is already in the final phase (#{game.phase})" }, status: :unprocessable_entity
      return
    end

    game.update!(phase: PHASES[current_index + 1])

    render json: {
      message: "Jogo avançou para #{game.phase}",
      community_cards: game.community_cards
    }
  end


  def action
    game = Game.find(params[:id])
    player = Player.find(params[:player_id])
    action_type = params[:action_type].to_s.downcase
    amount = params[:amount].to_i
    phase = game.phase

    unless game.room.players.include?(player)
      render json: { error: "you are not part of this room" }, status: :forbidden
      return
    end

    unless %w[call raise fold].include?(action_type)
      render json: { error: "invalid action" }, status: :unprocessable_entity
      return
    end

    if %w[call raise].include?(action_type) && amount > player.chips
      render json: { error: "not enough chips" }, status: :unprocessable_entity
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
      rank = HandEvaluator.evaluate(all_cards)

      {
        player_game: pg,
        player: pg.player,
        rank: rank
      }
    end

    winner = evaluations.max_by { |data| data[:rank] }

    if winner.nil?
      render json: { message: "No valid winner could be determined." }, status: :unprocessable_entity
      return
    end

    GameResult.create!(
      game: game,
      winner: winner[:player],
      hand_type: winner[:rank],
      pot: game.pot
    )

    render json: {
      message: "game finished",
      winner: {
        id: winner[:player].id,
        name: winner[:player].name,
        hand: winner[:player_game].cards,
        hand_type: winner[:rank]
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
