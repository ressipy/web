defmodule RessipyWeb.Api.UserTokenView do
  use RessipyWeb, :view

  def render("create.json", %{token: token}) do
    %{token: token}
  end
end
