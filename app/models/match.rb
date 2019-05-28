class Match < ApplicationRecord
  belongs_to :competition
  belongs_to :home_team, :class_name => :Team,:foreign_key => "home_team_id"
  belongs_to :away_team, :class_name => :Team,:foreign_key => "away_team_id"
  has_many :campaigns, through: :competitions 
  has_many :squads, through: :home_team
  has_many :squads, through: :away_team
  has_many :players, through: :squads 
end
