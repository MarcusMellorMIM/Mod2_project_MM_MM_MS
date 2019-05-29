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

    

end
