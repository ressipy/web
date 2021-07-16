defmodule RessipyWeb.Api.FallbackController do
  @moduledoc false

  use RessipyWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:bad_request)
    |> put_view(RessipyWeb.ErrorView)
    |> render(:"400", changeset: changeset)
  end

  def call(conn, nil) do
    conn
    |> put_status(:not_found)
    |> put_view(RessipyWeb.ErrorView)
    |> render(:"404")
  end
end
