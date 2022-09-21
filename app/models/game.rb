class Game < ApplicationRecord
  # Validations
  validates :name, presence: true, uniqueness: true
  validates :summary, presence: true
  validates :rating, allow_blank: true, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 100}
  validate :parent
  validate :child

  def parent
    if category == "main_game" && !parent_id.nil?
      errors.add(:parent_id, "must be blank. Select no parent game")
    end
  end
  def child
    if category == "expansion" && parent_id.nil?
      errors.add(:parent_id, "must not be blank. Select parent game")
    end
  end
  
  # associations
  has_many :involved_companies, dependent: :destroy
  has_many :companies, through: :involved_companies
  has_and_belongs_to_many :platforms
  has_and_belongs_to_many :genres
  has_many :expansions, class_name: "Game",
                        foreign_key: "parent_id",
                        dependent: :destroy,
                        inverse_of: "parent"

  belongs_to :parent, class_name: "Game", optional: true
  has_many :critics, as: :criticable, dependent: :destroy

  enum category: { main_game: 0, expansion: 1 }

  has_one_attached :cover
end
