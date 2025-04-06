class HandEvaluator
  HAND_RANKS = {
    high_card: 0,
    pair: 1,
    two_pair: 2,
    three_of_a_kind: 3,
    straight: 4,
    flush: 5,
    full_house: 6,
    four_of_a_kind: 7,
    straight_flush: 8,
    royal_flush: 9
  }

  RANK_ORDER = "23456789TJQKA".chars

  def self.evaluate(cards)
    ranks = cards.map { |c| c[0] }
    suits = cards.map { |c| c[1] }

    rank_counts = ranks.tally
    suit_counts = suits.tally

    flush_suit = suit_counts.key(5) || suit_counts.key(6) || suit_counts.key(7)
    flush_cards = flush_suit ? cards.select { |c| c[1] == flush_suit } : []

    unique_rank_indexes = ranks.uniq.map { |r| RANK_ORDER.index(r) }.compact.sort
    straight = detect_straight(unique_rank_indexes)

    if flush_cards.size >= 5
      flush_ranks = flush_cards.map { |c| c[0] }
      straight_flush = detect_straight(flush_ranks.map { |r| RANK_ORDER.index(r) }.compact.sort)

      if straight_flush
        return HAND_RANKS[:royal_flush] if straight_flush.max == RANK_ORDER.index("A")
        return HAND_RANKS[:straight_flush]
      end
    end

    if rank_counts.values.include?(4)
      HAND_RANKS[:four_of_a_kind]
    elsif rank_counts.values.sort.reverse[0..1] == [ 3, 2 ]
      HAND_RANKS[:full_house]
    elsif flush_cards.size >= 5
      HAND_RANKS[:flush]
    elsif straight
      HAND_RANKS[:straight]
    elsif rank_counts.values.include?(3)
      HAND_RANKS[:three_of_a_kind]
    elsif rank_counts.values.count(2) >= 2
      HAND_RANKS[:two_pair]
    elsif rank_counts.values.include?(2)
      HAND_RANKS[:pair]
    else
      HAND_RANKS[:high_card]
    end
  end

  def self.detect_straight(indexes)
    return nil if indexes.size < 5

    indexes = indexes.uniq.sort
    indexes += [ -1 ] if indexes.include?(12) && indexes.include?(0)

    indexes.each_cons(5) do |sequence|
      return sequence if sequence.each_cons(2).all? { |a, b| b == a + 1 }
    end

    nil
  end
end
