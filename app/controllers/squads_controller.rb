class SquadsController < ApplicationController


  before_action :find_squad, only:[:show,:edit,:update,:destroy]


  def index
    @squads = Squad.all

  end


  def new
    @squad = Squad.new
    @available_players = Player.all.select{|player| player.teams == []}
    @team = Team.find(params[:team_id])
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
  @squad = Squad.find_squad
  @squad.destroy
  redirect_to squads_path
end 


  
  private

  def find_squad
    Squad.find(params[:id])
  end

  def squad_params
    params.require(:squad).permit(:team_id,:player_id)
  end
  
end
