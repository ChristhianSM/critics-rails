class Genre < ApplicationRecord
  # associations
  has_and_belongs_to_many :games
end
