class TeamsController < ApplicationController

  before_action :find_team, only: [:show,:edit,:update,:destroy]
  before_action :authorized?
  skip_before_action :authorized?, only: [:index]

  def index
    @teams = Team.all
  end

  def new
    @team = Team.new
  end

  def show
  end

  def create
    @team = Team.new(team_params)
    if @team.valid?
      @team.save
      redirect_to team_path(@team)
    else
      flash[:errors]=@team.errors.full_messages
      redirect_to new_team_path
    end
  end

  def edit
  end

  def update
    @team.update(team_params)
    if @team.valid?
      redirect_to @team
    else
      flash[:errors] = @team.errors.full_messages
      redirect_to edit_team_path
    end
  end


  def destroy
    if @team.players.length > 0 
      @team.squads.each do |squad|
        squad.destroy
      end
        if @team.competitions.length > 0
          @team.campaigns.each do |campaign|
            campaign.destroy
            @team.destroy
          end
      else
        @team.destroy
      end
    elsif @team.competitions.length > 0
      @team.campaigns.each do |campaign|
        campaign.destroy
        @team.destroy
      end
    else
      @team.destroy
    end
    redirect_to teams_path
  end

  private

  def find_team
    @team = Team.find(params[:id])
  end

  def team_params
    params.require(:team).permit(:name)
  end
end
