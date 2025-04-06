require "test_helper"

class HandEvaluatorTest < ActiveSupport::TestCase
  test "detecta royal flush" do
    cards = [ "A♠", "K♠", "Q♠", "J♠", "T♠" ]
    result = HandEvaluator.evaluate(cards)
    assert_equal 9, result[:rank]
    assert_equal "royal_flush", result[:type]
  end

  test "detecta straight flush" do
    cards = [ "9♦", "8♦", "7♦", "6♦", "5♦" ]
    result = HandEvaluator.evaluate(cards)
    assert_equal 8, result[:rank]
    assert_equal "straight_flush", result[:type]
  end

  test "detecta four of a kind" do
    cards = [ "9♣", "9♦", "9♠", "9♥", "K♠" ]
    result = HandEvaluator.evaluate(cards)
    assert_equal 7, result[:rank]
    assert_equal "four_of_a_kind", result[:type]
  end

  test "detecta full house" do
    cards = [ "J♣", "J♦", "J♠", "7♣", "7♠" ]
    result = HandEvaluator.evaluate(cards)
    assert_equal 6, result[:rank]
    assert_equal "full_house", result[:type]
  end

  test "detecta flush" do
    cards = [ "2♣", "5♣", "8♣", "J♣", "K♣" ]
    result = HandEvaluator.evaluate(cards)
    assert_equal 5, result[:rank]
    assert_equal "flush", result[:type]
  end

  test "detecta straight" do
    cards = [ "5♠", "6♦", "7♣", "8♥", "9♦" ]
    result = HandEvaluator.evaluate(cards)
    assert_equal 4, result[:rank]
    assert_equal "straight", result[:type]
  end

  test "detecta three of a kind" do
    cards = [ "4♦", "4♣", "4♠", "K♠", "7♣" ]
    result = HandEvaluator.evaluate(cards)
    assert_equal 3, result[:rank]
    assert_equal "three_of_a_kind", result[:type]
  end

  test "detecta two pair" do
    cards = [ "5♦", "5♣", "9♠", "9♥", "K♦" ]
    result = HandEvaluator.evaluate(cards)
    assert_equal 2, result[:rank]
    assert_equal "two_pair", result[:type]
  end

  test "detecta pair" do
    cards = [ "2♠", "2♦", "7♣", "J♠", "Q♥" ]
    result = HandEvaluator.evaluate(cards)
    assert_equal 1, result[:rank]
    assert_equal "pair", result[:type]
  end

  test "detecta high card" do
    cards = [ "2♠", "4♦", "7♣", "J♠", "Q♥" ]
    result = HandEvaluator.evaluate(cards)
    assert_equal 0, result[:rank]
    assert_equal "high_card", result[:type]
  end
end
