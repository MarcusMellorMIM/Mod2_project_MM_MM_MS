class Competition < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :matches
  has_many :campaigns
  has_many :teams, through: :campaigns
  has_many :squads, through: :teams
  has_many :players, through: :squads 


  def matches_by_round( search_round_no )
    self.matches.select { |m| m.round_no == search_round_no }
  end

  def largest_round_no 
    matches.max {|m| m.round_no }.round_no
  end 


  def generate_matches 

    # Clear the matches, already created .... really important that the web page does not run this
    # if matches have been played.
    if self.matches 
        self.matches.destroy_all
    end 

    if knockout
      # Create the first round of matches for a knockout tournament
      Match.create generate_knockout
    else 
      # Treat like a season, so each team plays each team twice, once home and once away
      Match.create generate_season
    end
  end

  def generate_knockout 
    match_array = []
    counter=0
    # Get the teams into an array, so we can manipulate them
      team_array = self.teams.map {|team| team.id }      
      while team_array.length > 0
        counter += 1
        team1 = team_array.delete(team_array.sample)
        if team_array.length>0 
          team2 = team_array.delete(team_array.sample)
        else
          team2 = team1
        end 
        match_hash = { competition_id: self.id, home_team_id:team1, away_team_id:team2, round_no: 1, sequence_no: counter, replay_flag:'Y'   }
        match_array << match_hash 
      end
      match_array
  end 

  def generate_season 
     match_array = [] # Will capture all of the matches
    # Get the teams into an array, so we can manipulate them
      team_array = self.teams.map {|team| team.id } # Get the team ids into an array

    # Set the variables for the  1st week,
      home_index=0
      away_index=team_array.length-1
      inround_iterations=(team_array.length) / 2
      incampaign_iterations=team_array.length - 1 # will build half the rounds
      round_no = 0

# Plan is to increase home, and reduce away creating unique matches
    incampaign_iterations.times do
      round_no = round_no+1
      counter = 0
      inround_iterations.times do
        counter += 1
        match_hash = { competition_id: self.id, home_team_id:team_array[home_index], away_team_id:team_array[away_index], round_no: round_no*2, sequence_no: counter, replay_flag:'Y'   }
        match_array << match_hash
        home_index=home_index+1 
        away_index=away_index-1
        if home_index>team_array.length-1 
          home_index=0 
        end
        if away_index<0 
          away_index = team_array.length-1 
        end 

      end # End of weekly iteration
      home_index=round_no # Moves the start of the index to the next match
      away_index=round_no-1 # We dont need to check if the away index needs to be 0 here

   end # End of campaign iteration

  # We should create these matches, then iterate over the hash array, swopping the home away teams etc
  # and then reduce the round_no by 1

# UPTO HERE .... THE FOLLOWING MAKES THE CODE STICK ... NEED RTO FIGURE IT OUT
    match2_array = []
    match_array.each do |match|
      match_hash = { competition_id: self.id, home_team_id:match[:away_team_id], away_team_id:match[:home_team_id], round_no: match[:round_no]-1, replay_flag:'Y' }
      match2_array << match_hash
    end 

    match_array + match2_array # Push into Match.create 

# Great debuggers
#    c2 = Competition.last
#   myarray=c2.generate_matches
# c2.teams.map {|t| t.id }
# myarray.map {|round| puts "#{round[:round_no]} #{round[:home_team_id]} #{round[:away_team_id]}" }
  end  # End of season generator

end
