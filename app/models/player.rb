class Player < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :squads
  has_many :teams, through: :squads
  has_many :campaigns, through: :teams
  has_many :competitions, through: :campaigns 
  has_many :matches, through: :competitions

  def self.unallocated_players 
    self.all.select{|player| player.teams == []}
  end

  def self.order_unallocated_players( search_option=nil )
    if search_option == "Goalkeeper"
      unallocated_players.sort {|a,b| b.goalkeeper_skill <=> a.goalkeeper_skill}     
    elsif search_option == "Defender"
      unallocated_players.sort {|a,b| b.defender_skill <=> a.defender_skill}           
    elsif search_option == "Midfield"
      unallocated_players.sort {|a,b| b.midfielder_skill <=> a.midfielder_skill}           
    elsif search_option == "Striker"
      unallocated_players.sort {|a,b| b.striker_skill <=> a.striker_skill}           
    else
      unallocated_players
    end
  end 

end
