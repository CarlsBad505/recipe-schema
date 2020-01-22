class CreateFavorites < ActiveRecord::Migration[6.0]
  def change
    create_table :favorites do |t|
      t.integer :user_id, index: true
      t.integer :recipe_id, index: true
      t.timestamps
    end
  end
end
