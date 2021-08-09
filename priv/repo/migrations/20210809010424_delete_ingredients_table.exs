defmodule Ressipy.Repo.Migrations.DeleteIngredientsTable do
  use Ecto.Migration

  def change do
    drop table(:recipe_ingredients)
    drop table(:ingredients)
  end
end
