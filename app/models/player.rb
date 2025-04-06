class Player < ApplicationRecord
    has_many :room_players
    has_many :rooms, through: :room_players
    
    before_create :set_default_chips
  
    private
  
    def set_default_chips
      self.chips ||= 1000
    end
  end
  