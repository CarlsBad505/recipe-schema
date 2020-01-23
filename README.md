## Active Record Queries


**All foods with less than 10 grams of fat where the string "pizza" appears somewhere in the name**
```
Food.where("fat < ? and name like ?", 10, "%pizza%")
```

Basically, we string together a conditional `where` clause based on the criteria.

---

**All recipes that have been favorited by at least 1 user.**
```
Recipe.joins(:favorites).distinct
```

We `joins` the favorites table and call `distinct` on it to return only recipes that have been favorited by at least 1 person. This could even be written as a scope in the model like this...

```
class Recipe < ApplicationRecord
  scope :favorited, -> { joins(:favorites).distinct }
```

---

**All recipes that have not been favorited by any users**
```
Recipe.left_outer_joins(:favorites).where(favorites: {recipe_id: nil})
```

We `left_outer_joins` the favorites table because we want all the records in the Recipe table that satisfies a `where` condition. We then add a `where` clause to return all recipes that don't have a joins in the favorites table.

---

**All recipes that have a food with the name "avocado" or "broccoli" as an ingredient**
```
Recipe.joins(:foods).where("foods.name = ? or foods.name = ?", "avocado", "broccoli")
```

We `joins` the foods table, which will find the association through the joins table `foods_recipes`. We then add a `where` conditional clause.

---

**The names and IDs of all foods that are either ingredients of the recipe with ID 42 or ingredients of its child recipes. If a food is an ingredient of both the recipe and one or more of its child recipes, its name and ID should only appear once**
```
Recipe.joins("JOIN recipe_descendants ON recipes.id = recipe_descendants.child_id OR recipes.id = 42 WHERE recipe_descendants.parent_id = 42").left_outer_joins(:foods).select('foods.id', 'foods.name').distinct
```

This one was pretty complicated, we're joining across 3 tables, 5 if you consider the join tables themselves. Here we find recipes that either have an id = 42 or child recipes that have a parent id = 42. Then we list out the food ids and names making sure to return only distinct values.

---

**Optional Challenge: The names and IDs of all foods that are either ingredients of the recipe with ID 42 or ingredients of its descendant recipes (i.e. of this recipe's child recipes, and their child recipes, and their child recipes, ..., etc.). Similarly, foods should only appear once.**
```
def find_ingredients
  recipe = Recipe.find_by_id(42)
  return 'recipe_not_found' unless recipe

  @ingredients = recipe.foods.select(:id, :name).to_a
  if recipe.child_recipes.present?
    recursive_child_recipes(recipe)
  end
  @ingredients.uniq
end

def recursive_child_recipes(recipe)
  recipe.child_recipes.each do |cr|
    @ingredients << cr.foods.select(:id, :name).to_a
    recursive_child_recipes(cr) if cr.child_recipes.present?
  end
end
```

Because we don't really know how many nested child recipes there could be, it doesn't quite make sense to do a single SQL query for this one. We need to do something a little more sophisticated, some recursion in a loop until all nested outcomes have been discovered. After doing this, we can return a unique array of ingredients / foods.

---

## Description

To understand the rationale behind the schema, we also must understand the associations which is found in each model. I highly suggest looking at the models as it'll help supplement the roles between tables and joins tables.

The User table is pretty straight forward, it only has one type of association. A user can have many recipes and a recipe can have many users too. This `has_many` to `has_many` relationship warrants a joins table which we call `favorites`.

Next we have the Recipe and Foods table. Again, we have another `has_many` to `has_many` relationship. We create another joins table called `foods_recipes`, but this table is special because it also has an additional attribute called `quantity`. We use the `quantity` attribute here to track how many of each food belongs to a specific recipe.

Finally, we have possible recursive relationships between differing instances of a Recipe. To accomplish this, we create another joins table called `recipe_descendants` where we can track the child vs the parent of the exact same Model. Like `foods_recipes`, we also have a `quantity` field in here, in case there multiple child recipes of the same instance (guacamole recipe quantity 2, for a quesadilla recipe).

Specifically regarding fields in all tables, we have options like `null: false` if a field is required. We also index important fields like unique identifiers. While indexing does speed up queries, it unfortunately does slow down INSERTS so we need to be cognizant about this. We index fields like a Food name or Recipe name because those are required to be unique. In addition to validating uniqueness in the model, we should also do it at the DB level / schema in case to INSERTS happen at the same time.

One downside to having a Recipe table with a Recipe Descendants joins table to track parent vs child relationships is the fact that we now have to rely on recursion when querying for instances. Recursion is a more expensive operation because it requires more memory allocation vs iteration. A different option, we could make the Recipe table polymorphic and have two types of recipes in there instead... Child and Parent.
