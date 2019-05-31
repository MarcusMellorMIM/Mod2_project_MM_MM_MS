class Match < ApplicationRecord

  belongs_to :competition
  belongs_to :home_team, :class_name => :Team,:foreign_key => "home_team_id"
  belongs_to :away_team, :class_name => :Team,:foreign_key => "away_team_id"
  has_many :campaigns, through: :competitions 
  has_many :squads, through: :home_team
  has_many :squads, through: :away_team
  has_many :players, through: :squads 
  has_many :match_formations

  def reset
    # Initialise the models
    self.match_formations.destroy_all
    self.home_goals=nil
    self.away_goals=nil
    self.save
  end

  def allocate

    if replay_flag=='Y'
# Initialise the models, to be sure
    reset
# Ok, my idea is we pretend a formation, so in future we can set this on the model
# 1st number is defenders, 2nd number is midfield, and then strikers.
    get_formation( self.home_team )
    get_formation ( self.away_team )
# Once we have the team setup, we can store in matches.formation or keep in memory
    end # End the check on if a match can be replayed.
end


  def play 
    # Then we use the midfielder score to identify how many attacks we have
    # Use the defender score to see how many are stopped
    # Use the goalkeeper score to see how many are saved
    
    # We store the plays, into memory or a class object
    
    # At the end, if we don't have a class .... we can save the scores, allocating points.
    if replay_flag=='Y'

      self.home_goals = play_match( self.home_team, self.away_team )
      self.away_goals = play_match( self.away_team, self.home_team )
      self.save

    # Now check if this is a tournament, and the other match has finished as well
    # as long as there is a winner
    if self.competition.knockout && home_goals != away_goals
      # See if this is the end of the tournemant
      # So, count the number of teams in round 1, make sure mod%2, then halve it.
      # this is the max_round_no ..... so, if we are on that ... we do not generate any more
      # match records.
      max_round_no = competition.matches.select { |m| m.round_no==1 }.length

      if round_no < max_round_no # this means we can create another round
  
        # See if the other match has finished
         if (self.sequence_no % 2) == 1
          search_sequence_no = self.sequence_no + 1
          next_sequence_no = search_sequence_no / 2
        else 
          search_sequence_no = self.sequence_no - 1
          next_sequence_no = self.sequence_no / 2
        end

        this_match_winner = self.winner 
        other_match = Match.where( "competition_id = ? and round_no = ? and sequence_no = ?", competition, round_no, search_sequence_no ).first
        if other_match 

          if this_match_winner && other_match.winner
            self.replay_flag='N'
            self.save
            other_match.replay_flag='N'
            other_match.save
            Match.create(home_team_id:this_match_winner.id, away_team_id:other_match.winner.id, round_no:self.round_no+1, sequence_no:next_sequence_no, competition_id:competition.id, replay_flag:'Y' ) 
            other_match.save
            self.save
          end

        else # In this case, there isn't another match .... so probably odd - hence create a match with same team
           self.replay_flag='N'
           self.save 
           Match.create(home_team_id:this_match_winner.id, away_team_id:this_match_winner.id, round_no:self.round_no+1, sequence_no:next_sequence_no, competition_id:competition.id, replay_flag:'Y' ) 
          end
     end
    end # End of the check if this is the last round.
  end # end the replay check
  end

  def winner
    if self.home_goals && self.away_goals
      if self.home_goals > self.away_goals
       self.home_team 
     elsif self.away_goals > self.home_goals 
       self.away_team
     end
    end
  end

  def match_result 
    if self.home_goals then # The match has been played
        return_result = "#{home_goals} / #{away_goals}"
    end
  end

  def match_result_text 
    if self.home_goals 
      if winner
        result= "Won by #{winner.name}"
      else
        result= "It is a draw"       
      end
    end  
  end 

  def play_match( attack_team, defence_team )
    # Loop through the strikers, and see if they can score
    strikers = get_players( attack_team, "Striker" )
    midfield_skill = get_skills( attack_team, "Midfield")
    defence_skill = get_skills( defence_team, "Defence")
    goalkeeper_skill = get_skills( defence_team, "Goalkeeper")

    counter=0
    results = {
      shots:0,
      goals:0,
      defended:0,
      offtarget:0,
      saved:0,
      midfieldskill:midfield_skill
    }

    total_goals = 0

    strikers.each do |striker|
      
      # For each striker, get a number of shots, with an equal chance of
      # there being none, double, or the same

      total_shots = (((midfield_skill / 100) + 1 ) * (rand 3)+1)
      results[:shots]+=total_shots

       total_shots.times do
           ontarget = true

         # Did they get past the defence ?
           if striker.skill_index * (rand 5) < defence_skill * (rand 5)
             ontarget = false
             results[:defended]+=1
           end

         # Did they shoot on target ?
           if (rand 5) == 0 && ontarget
             ontarget = false
             results[:offtarget]+=1
           end
         # Did the goaly save it ?
           if striker.skill_index + (rand 100) > goalkeeper_skill + (rand 100) && ontarget
             # GOOOOOOOOOOAAAAAAAAAAAALLLLLLLLLLLLL
             total_goals += 1
             results[:goals]+=1
           else 
             ontarget = false
             results[:saved]+=1
           end
        end # End the attacks loop

        # Give each striker a 1 in 3 chance of scoring as a fluke
        if (rand 3)==3 
            total_goals+=1
        end

      end # End the strikers loop

    #results # Return the total goals 
      total_goals

    end # End the helper method

  def get_players( search_team, search_position )
    match_formations.select {|mf| mf.team_id == search_team.id && mf.position == search_position}
  end

  def get_skills( search_team, search_position)
    get_players( search_team, search_position ).map {|p| p.skill_index}.sum
  end 


  def get_formation( this_team )
# The goalkeeper is the highest rating goalkeeper
# The defenders are the highest rating defenders, etc etc etc
    team = []
    team = this_team.players.map {|p| p }
    team_qty = team.length

    if team_qty>0

      goalkeeper_qty = 1
      defender_qty = 4
      midfield_qty = 4
      striker_qty = 2

      counter = 0

      (11-team_qty).times do
       counter+=1
       if counter % 3 ==1
         if defender_qty>0
           defender_qty-=1
         end
       elsif counter % 3==2
         if midfield_qty>0
           midfield_qty-=1
         end
       else
         if striker_qty>0
           striker_qty-=1
         end
       end      
      end

    
      player=team.sort {|a,b| b.goalkeeper_skill <=> a.goalkeeper_skill}.first
      MatchFormation.create( match_id:self.id, team_id:this_team.id, player_id:player.id, position:"Goalkeeper", skill_index:player.goalkeeper_skill)
      team.delete(player)

    defender_qty.times do
      player = team.sort {|a,b| b.defender_skill <=> a.defender_skill}.first
      if player
        team.delete(player)
         MatchFormation.create( match_id:self.id,  team_id:this_team.id, player_id:player.id, position:"Defender", skill_index:player.defender_skill)
      end
    end 

    midfield_qty.times do
      player = team.sort {|a,b| b.midfielder_skill <=> a.midfielder_skill}.first
      if player
        team.delete(player)
       MatchFormation.create( match_id:self.id,  team_id:this_team.id, player_id:player.id, position:"Midfield", skill_index:player.midfielder_skill )
      end 
    end

   striker_qty.times do
      player = team.sort {|a,b| b.striker_skill <=> a.striker_skill}.first
      if player
        team.delete(player)
        MatchFormation.create( match_id:self.id,  team_id:this_team.id, player_id:player.id, position:"Striker", skill_index:player.striker_skill)
      end 
    end

    end # No players in the team

  end 

end
