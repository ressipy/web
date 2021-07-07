defmodule Ressipy.Repo.Migrations.AddRoleToUsers do
  use Ecto.Migration

  def change do
    user_role_enum_query = %{
      create: "CREATE TYPE user_role AS ENUM ('admin', 'editor', 'user')",
      drop: "DROP TYPE user_role"
    }

    execute(user_role_enum_query.create, user_role_enum_query.drop)

    alter table(:users) do
      add :role, :user_role, null: false, default: "user"
    end
  end
end
