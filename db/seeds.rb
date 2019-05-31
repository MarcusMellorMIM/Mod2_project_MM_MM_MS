# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Squad.destroy_all
Campaign.destroy_all
Match.destroy_all
Player.destroy_all
Team.destroy_all
Competition.destroy_all


160.times do
  Player.create(name: Faker::Name.unique.name, 
    dob: Faker::Date.birthday(18, 40), 
    gender: Faker::Gender.binary_type,
    goalkeeper_skill: Faker::Number.between(1, 100), 
    defender_skill: Faker::Number.between(1, 100),
    midfielder_skill: Faker::Number.between(1, 100),
    striker_skill: Faker::Number.between(1, 100),
    height_cm: Faker::Number.between(150, 210),
    weight_kg: Faker::Number.between(60, 100)
      )
end

10.times do
  Team.create(name: Faker::Football.unique.team)
end

# Loop through all players, and insert into squad

Player.all.each do |player|
  Squad.create(team_id: Team.ids.sample, player_id: player.id)
end



40.times do
  Player.create(name: Faker::Name.unique.name, 
    dob: Faker::Date.birthday(18, 40), 
    goalkeeper_skill: Faker::Number.between(1, 100), 
    defender_skill: Faker::Number.between(1, 100),
    midfielder_skill: Faker::Number.between(1, 100),
    striker_skill: Faker::Number.between(1, 100),
    height_cm: Faker::Number.between(150, 210),
    weight_kg: Faker::Number.between(60, 100)
      )
end

# Then generate 20 more players
