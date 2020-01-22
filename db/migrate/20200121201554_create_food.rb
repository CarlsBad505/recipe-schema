class CreateFood < ActiveRecord::Migration[6.0]
  def change
    create_table :foods do |t|
      t.string :name, null: false, index: {unique: true}
      t.integer :calories, null: false
      t.integer :carbohydrates, null: false
      t.integer :protein, null: false
      t.integer :fat, null: false
      t.timestamps
    end
  end
end
