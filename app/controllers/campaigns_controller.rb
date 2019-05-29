class CampaignsController < ApplicationController
    before_action :find_campaign, only:[:show,:edit,:update,:destroy]

    def index
      @campaigns = Campaign.all
    end
  
  
    def new
      @campaign = Campaign.new
      @team = Team.find(params[:team_id])
    end
  
    def show
    end
  
    def create
      params[:competition_ids].each do |competition_id|
        Campaign.create({:team_id => params[:team_id], :competition_id => competition_id})
      end
      redirect_to team_path(params[:team_id])
      
      # @campaign = Campaign.new(campaign_params)
      # if @campaign.valid?
      #   @campaign.save
      #   redirect_to campaign_path(@campaign)
      # else
      #   flash[:errors]=@campaign.errors.full_messages
      #   redirect_to new_campaign_path
    end

    def edit
    end
  
    def update
      @campaign.update(campaign_params)
      if @campaign.valid?
        redirect_to @campaign
      else
        flash[:errors] = @campaign.errors.full_messages
        redirect_to edit_campaign_path
      end
    end
  
  
    def destroy
    @campaign.destroy
    redirect_to campaigns_path
  end 
  
  
    
    private
  
    def find_campaign
      @campaign = Campaign.find(params[:id])
    end
  
    def campaign_params
      params.require(:campaign).permit(:team_id,:competition_id)
    end
  
  end
