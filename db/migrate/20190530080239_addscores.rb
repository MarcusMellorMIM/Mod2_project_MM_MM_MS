class Addscores < ActiveRecord::Migration[5.2]
  def change
    add_column :matches, :home_goals, :integer
    add_column :matches, :away_goals, :integer
  end
end
