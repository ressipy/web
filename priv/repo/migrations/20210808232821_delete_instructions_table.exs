defmodule Ressipy.Repo.Migrations.DeleteInstructionsTable do
  use Ecto.Migration

  def change do
    drop table(:instructions)
  end
end
