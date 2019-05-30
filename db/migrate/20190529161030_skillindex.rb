class Skillindex < ActiveRecord::Migration[5.2]
  def change
    add_column :match_formations, :skill_index, :integer
  end
end
