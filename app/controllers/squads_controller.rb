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
    @available_players = Player.order_unallocated_players( search_option )
  
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
