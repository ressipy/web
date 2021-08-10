defmodule RessipyWeb.Api.UserTokenView do
  use RessipyWeb, :view

  def render("create.json", assigns) do
    permissions =
      for permission <- assigns.permissions do
        permission |> to_string() |> Recase.to_camel()
      end

    %{permissions: permissions, token: assigns.token}
  end
end
