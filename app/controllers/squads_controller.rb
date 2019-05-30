class SquadsController < ApplicationController


  before_action :find_squad, only:[:show,:edit,:update,:destroy]
  before_action :authorized?
  skip_before_action :authorized?, only: [:index]


  def index
    @squads = Squad.all

  end


  def new
    @squad = Squad.new
    @team = Team.find(params[:team_id])
    search_option = params[:position]
    if search_option == "Goalkeeper"
      @available_players = Player.all.select{|player| player.teams == []}.sort {|a,b| b.goalkeeper_skill <=> a.goalkeeper_skill}     
    elsif search_option == "Defender"
      @available_players = Player.all.select{|player| player.teams == []}.sort {|a,b| b.defender_skill <=> a.defender_skill}           
    elsif search_option == "Midfield"
      @available_players = Player.all.select{|player| player.teams == []}.sort {|a,b| b.midfielder_skill <=> a.midfielder_skill}           
    elsif search_option == "Striker"
      @available_players = Player.all.select{|player| player.teams == []}.sort {|a,b| b.striker_skill <=> a.striker_skill}           
    else
      @available_players = Player.all.select{|player| player.teams == []} 
    end 
  
  end

  def show
    @squad = Squad.find_squad
  end

  def create
    params[:player_ids].each do |player_id|
      Squad.create({:team_id => params[:team_id], :player_id => player_id})
    end
    redirect_to team_path(params[:team_id])
    # @squad = squad.new(squad_params)
    # if @squad.valid?
    #   @squad.save
    #   redirect_to squad_path(@squad)
    # else
    #   flash[:errors]=@squad.errors.full_messages
    #   redirect_to new_squad_path
    # end
  end

  def update
    @squad.update(squad_params)
    if @squad.valid?
      redirect_to @squad
    else
      flash[:errors] = @squad.errors.full_messages
      redirect_to edit_squad_path
    end
  end


  def destroy
    team = Team.find(@squad.team_id)
    @squad.destroy
    redirect_to team_path(team)
end 


  
  private

  def find_squad
    @squad = Squad.find(params[:id])
  end

  def squad_params
    params.require(:squad).permit(:team_id,:player_id)
  end
  
end
