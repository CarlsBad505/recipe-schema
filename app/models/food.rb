class Food < ApplicationRecord
  has_many :foods_recipes, dependent: :destroy
  has_many :recipes, through: :foods_recipes

  validates :name, :calories, :carbohydrates, :protein, :fat, presence: true
  validates :name, uniqueness: true
end
