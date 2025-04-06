require "test_helper"

class GamesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @player = Player.create!(name: "Jogador", chips: 1000)
    @room = Room.create!(name: "Mesa 1")
    @room.players << @player
    @game = Game.create!(room: @room, pot: 0, phase: "pre_flop")
  end

  test "realiza raise corretamente" do
    post action_game_url(@game), params: {
      player_id: @player.id,
      action_type: "raise",
      amount: 200
    }

    assert_response :success
    @player.reload
    @game.reload
    assert_equal 800, @player.chips
    assert_equal 200, @game.pot
  end

  test "bloqueia ação se jogador não está na sala" do
    outro = Player.create!(name: "Intruso", chips: 1000)
    post action_game_url(@game), params: {
      player_id: outro.id,
      action_type: "raise",
      amount: 100
    }

    assert_response :forbidden
  end

  test "bloqueia ação inválida" do
    post action_game_url(@game), params: {
      player_id: @player.id,
      action_type: "dançar",
      amount: 50
    }

    assert_response :unprocessable_entity
  end

  test "avança para a próxima fase corretamente" do
    assert_equal "pre_flop", @game.phase

    post next_phase_game_url(@game)

    assert_response :success
    @game.reload
    assert_equal "flop", @game.phase
  end

  test "bloqueia ação se jogador não tiver fichas suficientes" do
    post action_game_url(@game), params: {
      player_id: @player.id,
      action_type: "raise",
      amount: 2000
    }

    assert_response :unprocessable_entity
  end

  test "não permite finalizar jogo se não estiver no river" do
    post finish_game_url(@game)

    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert_equal "game must be at river to finish", json["message"]
  end

  test "finaliza jogo e retorna vencedor corretamente" do
    @game.update!(phase: "river")
    @player2 = Player.create!(name: "Segundo", chips: 1000)
    @room.players << @player2

    PlayerGame.create!(player: @player, game: @game, cards: [ "A♠", "K♠" ])
    PlayerGame.create!(player: @player2, game: @game, cards: [ "2C", "3D" ])
    @game.update!(community_cards: [ "Q♠", "J♠", "T♠", "2S", "9C" ])

    post finish_game_url(@game)

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "game finished", json["message"]
    assert_equal @player.id, json["winner"]["id"]
    assert_equal "royal_flush", json["winner"]["hand_type"]
  end
end
