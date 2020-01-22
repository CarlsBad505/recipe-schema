class Recipe < ApplicationRecord
  has_many :favorites, dependent: :destroy
  has_many :users, through: :favorites

  has_many :foods_recipes, dependent: :destroy
  has_many :foods, through: :foods_recipes

  has_many :recipe_descendants, foreign_key: :parent_id
  has_many :child_recipes, through: :recipe_descendants, source: :child

  validates :name, :instructions, presence: true
  validates :name, uniqueness: true
end
