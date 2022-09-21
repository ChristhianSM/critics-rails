class Company < ApplicationRecord
  # Validations
  validates :name, presence: true, uniqueness: true

  # association
  has_many :involved_companies, dependent: :destroy
  has_many :games, through: :involved_companies
  has_many :critics, as: :criticable, dependent: :destroy

  has_one_attached :cover
end
