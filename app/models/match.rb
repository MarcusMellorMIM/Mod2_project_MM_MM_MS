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
  end

  def allocate
# Initialise the models, to be sure
    reset
# Ok, my idea is we pretend a formation, so in future we can set this on the model
# 1st number is defenders, 2nd number is midfield, and then strikers.
    get_formation( self.home_team )
    get_formation ( self.away_team )
# Once we have the team setup, we can store in matches.formation or keep in memory
  end 


  def play 
    # Then we use the midfielder score to identify how many attacks we have
    # Use the defender score to see how many are stopped
    # Use the goalkeeper score to see how many are saved
    
    # We store the plays, into memory or a class object
    
    # At the end, if we don't have a class .... we can save the scores, allocating points.
    
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
      team.delete(player)
      MatchFormation.create( match_id:self.id,  team_id:this_team.id, player_id:player.id, position:"Defender", skill_index:player.defender_skill)
    end 

    midfield_qty.times do
      player = team.sort {|a,b| b.midfielder_skill <=> a.midfielder_skill}.first
      team.delete(player)
      MatchFormation.create( match_id:self.id,  team_id:this_team.id, player_id:player.id, position:"Midfield", skill_index:player.midfielder_skill )
    end

   striker_qty.times do
      player = team.sort {|a,b| b.striker_skill <=> a.striker_skill}.first
      team.delete(player)
      MatchFormation.create( match_id:self.id,  team_id:this_team.id, player_id:player.id, position:"Striker", skill_index:player.striker_skill)
    end

    end # No players in the team

  end 

end
