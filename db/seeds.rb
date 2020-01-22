user1 = User.create!(name: 'Ted', email: 'a_real_bear@gmail.com')
user2 = User.create!(name: 'Charlie', email: 'a_real_horse@gmail.com')

avocado = Food.create!(name: 'Avocado', calories: 50, carbohydrates: 50, protein: 20, fat: 5)
tomato = Food.create!(name: 'Tomato', calories: 30, carbohydrates: 10, protein: 2, fat: 1)
tortilla = Food.create!(name: 'Tortilla', calories: 100, carbohydrates: 50, protein: 2, fat: 5)
cheddar = Food.create!(name: 'Cheddar', calories: 100, carbohydrates: 40, protein: 5, fat: 10)
lime = Food.create!(name: 'Lime', calories: 5, carbohydrates: 1, protein: 0, fat: 0)
mozzarella = Food.create!(name: 'Mozzarella', calories: 200, carbohydrates: 50, protein: 10, fat: 50)
dough = Food.create!(name: 'Dough', calories: 150, carbohydrates: 40, protein: 4, fat: 15)
tomato_sauce = Food.create!(name: 'Tomato Sauce', calories: 100, carbohydrates: 30, protein: 2, fat: 8)

guacamole = Recipe.create!(name: 'Guacamole', instructions: 'instructions on how to make this...')
quesadilla = Recipe.create!(name: 'Quesadilla', instructions: 'instructions on how to make this...')
cheese_pizza = Recipe.create!(name: 'Cheese Pizza', instructions: 'instructions on how to make this...')

guacamole.foods_recipes.create(
  food_id: avocado.id,
  quantity: 2
)

guacamole.foods_recipes.create(
  food_id: tomato.id,
  quantity: 1
)

guacamole.foods_recipes.create(
  food_id: lime.id,
  quantity: 1
)

quesadilla.foods_recipes.create(
  food_id: cheddar.id,
  quantity: 1
)

quesadilla.foods_recipes.create(
  food_id: tortilla.id,
  quantity: 1
)

quesadilla.recipe_descendants.create(
  child_id: guacamole.id,
  quantity: 1
)

cheese_pizza.foods_recipes.create(
  food_id: dough.id,
  quantity: 1
)

cheese_pizza.foods_recipes.create(
  food_id: mozzarella.id,
  quantity: 1
)

cheese_pizza.foods_recipes.create(
  food_id: tomato_sauce.id,
  quantity: 1
)

user1.recipes << guacamole
user2.recipes << [guacamole, quesadilla]

puts "-"*30
puts "#{User.count} users created"
puts "#{Food.count} foods created"
puts "#{Recipe.count} recipes created"
puts "#{user1.name} has favorited #{user1.favorites.count} recipes"
puts "#{user2.name} has favorited #{user2.favorites.count} recipes"
puts "#{quesadilla.name} has #{quesadilla.child_recipes.count} recipe descendants"
puts "-"*30
puts "Seeding Finished..."
