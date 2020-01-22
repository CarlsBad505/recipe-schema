class CreateRecipe < ActiveRecord::Migration[6.0]
  def change
    create_table :recipes do |t|
      t.string :name, null: false, index: {unique: true}
      t.text :instructions, null: false
      t.timestamps
    end
  end
end
