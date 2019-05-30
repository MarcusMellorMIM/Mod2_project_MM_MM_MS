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
      if params[:commit]== "Reset"
        @match.reset
      elsif params[:commit]=="Allocate"
        @match.allocate
      elsif params[:commit]=="Play"
        @match.play
      end

      redirect_to @match
    end

end
