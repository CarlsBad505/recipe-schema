class CreateRecipeDescendant < ActiveRecord::Migration[6.0]
  def change
    create_table :recipe_descendants do |t|
      t.integer :child_id, index: true
      t.integer :parent_id, index: true
      t.integer :quantity, null: false
      t.timestamps
    end
  end
end
