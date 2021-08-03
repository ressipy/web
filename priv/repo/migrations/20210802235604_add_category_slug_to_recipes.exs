defmodule Ressipy.Repo.Migrations.AddCategorySlugToRecipes do
  use Ecto.Migration

  def change do
    alter table(:recipes) do
      add :category_slug, references("categories", column: :slug, type: :string)
    end

    create index(:recipes, [:category_slug])
  end
end
