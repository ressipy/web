defmodule Ressipy.Repo.Migrations.AddIngredientsToRecipes do
  use Ecto.Migration

  # After running this migration, ingredients will need to be migrated from
  # their own table into the new JSONB column. That can be done with the
  # following SQL query:
  #
  # UPDATE recipes
  #   SET ingredients = i.list
  #   FROM (
  #     SELECT recipe_id, JSON_AGG(JSON_BUILD_OBJECT('amount', i.amount, 'name', i.name)) AS list
  #       FROM (
  #         SELECT recipe_id, amount, name
  #           FROM recipe_ingredients ri
  #           JOIN ingredients i ON i.id = ri.ingredient_id
  #           ORDER BY ri.order
  #       ) i
  #       GROUP BY recipe_id
  #   ) i
  #   WHERE id = i.recipe_id;

  def change do
    alter table(:recipes) do
      add :ingredients, :map
    end
  end
end
