class CreateMatchFormations < ActiveRecord::Migration[5.2]
  def change
    create_table :match_formations do |t|
      t.integer   :match_id
      t.integer   :player_id
      t.string    :position
      t.timestamps
    end
  end
end
