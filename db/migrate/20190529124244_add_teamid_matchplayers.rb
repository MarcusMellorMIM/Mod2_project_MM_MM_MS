class AddTeamidMatchplayers < ActiveRecord::Migration[5.2]
  def change
    add_column :match_formations, :team_id, :integer
  end
end
