class CampaignsController < ApplicationController
    before_action :find_campaign, only:[:show,:edit,:update,:destroy]


    def index
      @campaigns = Campaign.all
  
    end
  
  
    def new
      @campaign = Campaign.new
  
    end
  
    def show
      @campaign = Campaign.find_campaign
    end
  
    def create
      @campaign = Campaign.new(campaign_params)
      if @campaign.valid?
        @campaign.save
        redirect_to campaign_path(@campaign)
      else
        flash[:errors]=@campaign.errors.full_messages
        redirect_to new_campaign_path
      end
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
    @campaign = Campaign.find_campaign
    @campaign.destroy
    redirect_to campaigns_path
  end 
  
  
    
    private
  
    def find_campaign
      Campaign.find(params[:id])
    end
  
    def campaign_params
      params.require(:campaign).permit(:team_id,:competition_id)
    end
  end
  
end
