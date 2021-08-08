defmodule Ressipy.Repo.Migrations.AddEmbeddedInstructionsToRecipes do
  use Ecto.Migration

  # After running this migration, instructions will need to be migrated from
  # their own table into the new JSONB column. That can be done with the
  # following SQL query:
  #
  # UPDATE recipes
  #   SET instructions = i.list
  #   FROM (
  #     SELECT recipe_id, JSON_AGG(JSON_BUILD_OBJECT('text', instructions.text)) AS list
  #       FROM instructions
  #       GROUP BY recipe_id
  #   ) i
  #   WHERE id = i.recipe_id;

  def change do
    alter table(:recipes) do
      add :instructions, :map
    end
  end
end
