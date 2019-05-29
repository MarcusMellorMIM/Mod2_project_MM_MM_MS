class PlayersController < ApplicationController
  before_action :find_player, only: [:show, :edit, :update, :destroy]

 

end
