class Campaign < ApplicationRecord
  belongs_to :team
  belongs_to :competition
  has_many :matches, through: :competitions
end
