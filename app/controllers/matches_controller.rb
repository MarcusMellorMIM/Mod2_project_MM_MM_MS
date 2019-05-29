class MatchesController < ApplicationController
    
    def index 
      @matches = Match.all 
    end 

    def new 
      @match = Match.new 
    end 

    def show 
      @match = Match.find(params[:id])
    end 

    def update
      @match = Match.find(params[:id])
      redirect_to @match
    end

end
