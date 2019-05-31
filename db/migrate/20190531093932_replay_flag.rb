class ReplayFlag < ActiveRecord::Migration[5.2]
  def change
    add_column :matches, :replay_flag, :string
  end
end
