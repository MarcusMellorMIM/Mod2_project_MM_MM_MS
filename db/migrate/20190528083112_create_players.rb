class CreatePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :players do |t|
      t.string :name
      t.date :dob
      t.string :gender
      t.integer :goalkeeper_skill
      t.integer :defender_skill
      t.integer :midfielder_skill
      t.integer :striker_skill
      t.float :height_cm
      t.float :weight_kg

      t.timestamps
    end
  end
end
