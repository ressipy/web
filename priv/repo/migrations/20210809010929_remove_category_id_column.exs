defmodule Ressipy.Repo.Migrations.RemoveCategoryIdColumn do
  use Ecto.Migration

  def change do
    alter table(:recipes) do
      remove :category_id
    end
  end
end
