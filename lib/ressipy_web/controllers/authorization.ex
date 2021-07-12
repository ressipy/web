defmodule RessipyWeb.Authorization do
  @moduledoc false

  import Plug.Conn, only: [halt: 1]
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  alias Ressipy.Authorization
  alias RessipyWeb.Router.Helpers, as: Routes

  def init(permission) do
    permission
  end

  def call(conn, permission) do
    if Authorization.can?(conn.assigns.current_user, permission) do
      conn
    else
      conn
      |> put_flash(:error, "You aren't authorized to access that page.")
      |> redirect(to: Routes.category_path(conn, :index))
      |> halt()
    end
  end
end
