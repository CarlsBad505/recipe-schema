class CreateFoodsRecipes < ActiveRecord::Migration[6.0]
  def change
    create_table :foods_recipes do |t|
      t.integer :food_id, index: true
      t.integer :recipe_id, index: true
      t.integer :quantity, null: false
      t.timestamps
    end
  end
end
