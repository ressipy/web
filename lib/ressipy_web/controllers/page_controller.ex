defmodule RessipyWeb.PageController do
  @moduledoc false

  use RessipyWeb, :controller

  def privacy_policy(conn, _params) do
    render(conn, "privacy_policy.html")
  end
end
