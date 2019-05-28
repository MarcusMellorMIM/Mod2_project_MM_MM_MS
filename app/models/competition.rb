class Competition < ApplicationRecord
  has_many :matches
  has_many :campaigns
  has_many :teams, through: :campaigns
  has_many :squads, through: :teams
  has_many :players, through: :squads 
end
