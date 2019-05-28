class Player < ApplicationRecord
  has_many :squads
  has_many :teams, through: :squads
  has_many :campaigns, through: :teams
  has_many :competitions, through: :campaigns 
  has_many :matches, through: :competitions
  
 
end
