class Team < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :squads
  has_many :players, through: :squads
  has_many :campaigns
  has_many :competitions, through: :campaigns 
  has_many :matches, through: :competitions
end
