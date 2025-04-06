class EvaluationsController < ApplicationController
  def evaluate_hand
    cards = params[:cards] # ex: ["AH", "KH", "QH", "JH", "TH"]
    rank_value = HandEvaluator.evaluate(cards)
    rank_name = HandEvaluator::HAND_RANKS.key(rank_value).to_s.humanize

    render json: {
      hand: cards,
      rank_name: rank_name,
      rank_value: rank_value
    }
  end
end
