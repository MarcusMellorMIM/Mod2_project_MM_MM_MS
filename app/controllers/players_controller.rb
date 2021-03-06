class PlayersController < ApplicationController
  before_action :find_player, only: [:show, :edit, :update, :destroy]
  before_action :authorized?
  skip_before_action :authorized?, only: [:index]

  def index
    if params[:gender]=="Female"
      @players=Player.all.select{|player| player.gender=="Female"}
    elsif params[:gender]=="Male"
      @players=Player.all.select{|player| player.gender=="Male"}
    else 
      @players = Player.all
    end 
  end
 
  def show
  end
  
  def new
    @player = Player.new
  end
 
  def create
    @player = Player.new(player_params)
    if @player.valid?
      @player.save
    
      if params[:player][:team_ids].length > 1
        team_ids = params[:player][:team_ids].slice(1..params[:player][:team_ids].length)
        team_ids.each do |team_id|
          Squad.create(player_id: @player.id, team_id: team_id.to_i)
        end
      end
    
      redirect_to player_path(@player)
    else
      flash[:errors]=@player.errors.full_messages
      redirect_to new_player_path
    end
  end

  def edit

  end

  def update
    if @player.teams.length > 0
      @player.squads.each do |squad|
        squad.destroy
      end
    end
    if params[:player][:team_ids].length > 1
      team_ids = params[:player][:team_ids].slice(1..params[:player][:team_ids].length)
      team_ids.each do |team_id|
        Squad.create(player_id: @player.id, team_id: team_id.to_i)
      end
    end
    @player.update player_params
    redirect_to @player
  end

  def destroy
    if @player.teams.length > 0
      @player.squads.each do |squad|
        squad.destroy
      end
    else
      @player.destroy
    end
    redirect_to players_path
  end
 
  private

  def player_params
    params.require(:player).permit(:name,:dob,:gender,:goalkeeper_skill,:defender_skill,:midfielder_skill,:striker_skill,:height_cm,:weight_kg)
  end

  def find_player
    @player = Player.find(params[:id])
  end

end