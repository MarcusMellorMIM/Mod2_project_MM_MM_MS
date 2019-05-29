class CompetitionsController < ApplicationController

  before_action :find_competition, only:[:show,:edit,:update,:destroy]


  def index
    @competitions = Competition.all
  end


  def new
    @competition = Competition.new
  end

  def show
  end

  def create
    @competition = Competition.new(competition_params)
    if @competition.valid?
      @competition.save
      redirect_to competition_path(@competition)
    else
      flash[:errors]=@competition.errors.full_messages
      redirect_to new_competition_path
    end
  end

  def update
    @competition.update(competition_params)
    if @competition.valid?
      redirect_to @competition
    else
      flash[:errors] = @competition.errors.full_messages
      redirect_to edit_competition_path
    end
  end


  def destroy
    @competition.destroy
    redirect_to competitions_path
  end 


  
  private

  def find_competition
    @competition = Competition.find(params[:id])
  end

  def competition_params
    params.require(:competition).permit(:name,:knockout)
  end
  
end


