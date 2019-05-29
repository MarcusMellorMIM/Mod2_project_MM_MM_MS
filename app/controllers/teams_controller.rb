class TeamsController < ApplicationController
<<<<<<< HEAD
=======
  before_action :find_team, only: [:show,:edit,:update,:destroy]
>>>>>>> f601ba7e7e857574d690e5dbca1429ce4dee65c9

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
<<<<<<< HEAD
  @team.destroy
  redirect_to teams_path
end 

=======
    @team.destroy
    redirect_to teams_path
  end 
>>>>>>> f601ba7e7e857574d690e5dbca1429ce4dee65c9

  private

  def find_team
<<<<<<< HEAD
    @team=Team.find(params[:id])
=======
    @team = Team.find(params[:id])
>>>>>>> f601ba7e7e857574d690e5dbca1429ce4dee65c9
  end

  def team_params
    params.require(:team).permit(:name)
  end
end
