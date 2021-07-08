defmodule RessipyWeb.Authorization do
  @moduledoc false

  import Plug.Conn
  import Phoenix.Controller

  alias Ressipy.Authorization
  alias RessipyWeb.Router.Helpers, as: Routes

  @doc """
  A simple plug that can be used for authorization checking on routes. It
  expects that a check has already run to ensure that a user is logged in, and
  that a current_user struct exists within the assigns on the connection.
  """
  def require_authorization(conn, permission) do
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
