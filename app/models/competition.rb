class Competition < ApplicationRecord
  has_many :matches
  has_many :campaigns
  has_many :teams, through: :campaigns
  has_many :squads, through: :teams
  has_many :players, through: :squads 

  def generate_matches 
    if knockout
      # Create the first round of matches for a knockout tournament
      Match.create generate_knockout
    else 
      # Treat like a season, so each team plays each team twice, once home and once away
      generate_season
    end
  end

  def generate_knockout 
    match_array = []
    # Get the teams into an array, so we can manipulate them
      team_array = self.teams.map {|team| team.id }      
      while team_array.length > 0
        team1 = team_array.delete(team_array.sample)
        if team_array.length>0 
          team2 = team_array.delete(team_array.sample)
        else
          team2 = team1
        end 
        match_hash = { competition_id: self.id, home_team_id:team1, away_team_id:team2, round_no: 1 }
        match_array << match_hash 
      end
      match_array
  end 


  def generate_season 
     match_array = []

    # Get the teams into an array, so we can manipulate them
      team_array = self.teams.map {|team| team.id }
      if team_array.length.mod(2)>0
        team_array << nil
      end 
      

      
      rounds = (team_array.length * 2) - 2
      matches = (team_array.length / 2)

      

  end 

end
