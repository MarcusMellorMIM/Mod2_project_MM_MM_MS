class CompetitionsController < ApplicationController

  before_action :find_competition, only:[:show,:edit,:update,:destroy, :matchesgenerator]

  def index
    @competitions = Competition.all
  end
  
  def new
    @competition = Competition.new
  end

  def show
  end

  def edit
  end 

  def create
    @competition = Competition.new(competition_params)
    if @competition.valid?
      @competition.save

      if params[:competition][:team_ids].length > 1
        team_ids = params[:competition][:team_ids].slice(1..params[:competition][:team_ids].length)
        team_ids.each do |team_id|
          Campaign.create(competition_id: @competition.id, team_id: team_id.to_i)
        end 
      end 
      redirect_to competition_path(@competition)
    else
      flash[:errors]=@competition.errors.full_messages
      redirect_to new_competition_path
    end
  end

  def update


    @competition.teams.length >0
    if @competition.campaigns.each do |campaign|
      campaign.destroy
    end 
  end 
  if params[:competition][:team_ids].length >1
    team_ids = params[:competition][:team_ids].slice(1..params[:competition][:team_ids].length)
    team_ids.each do |team_id|
      Campaign.create(competition_id: @competition_id, team_id:team_id)
    end 
  end 
      @competition.update competition_params
      redirect_to @competition
end 


  def destroy
    @competition.destroy
    redirect_to competitions_path
  end

  def matchesgenerator
    @competition.generate_matches
    redirect_to @competition
  end

  private

  def find_competition
    @competition = Competition.find(params[:id])
  end

  def competition_params
    params.require(:competition).permit(:name,:knockout)
  end
  
end

