defmodule Ressipy.Repo.Migrations.CreateRecipeTables do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string, null: false
      add :slug, :string, null: false

      timestamps()
    end

    create table(:ingredients) do
      add :name, :string

      timestamps()
    end

    create table(:recipes) do
      add :name, :string, null: false
      add :slug, :string, null: false
      add :author, :string
      add :default_image, :string
      add :category_id, references(:categories, on_delete: :nothing)

      timestamps()
    end

    create table(:instructions) do
      add :order, :integer
      add :text, :string
      add :recipe_id, references(:recipes, on_delete: :delete_all)

      timestamps()
    end

    create table(:recipe_ingredients) do
      add :amount, :string
      add :order, :integer
      add :recipe_id, references(:recipes, on_delete: :delete_all)
      add :ingredient_id, references(:recipe_ingredients, on_delete: :nothing)

      timestamps()
    end

    create index(:recipes, [:category_id])
    create index(:instructions, [:recipe_id])
    create index(:recipe_ingredients, [:recipe_id])
    create index(:recipe_ingredients, [:ingredient_id])
    create unique_index(:categories, [:slug])
    create unique_index(:recipes, [:slug])
  end
end
