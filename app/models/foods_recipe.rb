class FoodsRecipe < ApplicationRecord
  belongs_to :food
  belongs_to :recipe

  validates :quantity, presence: true
end
