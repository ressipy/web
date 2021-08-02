defmodule RessipyWeb.Api.FallbackController do
  @moduledoc false

  use RessipyWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:bad_request)
    |> put_view(RessipyWeb.ErrorView)
    |> render(:"400", changeset: changeset)
  end

  def call(conn, :invalid_login) do
    conn
    |> put_status(:unauthorized)
    |> put_view(RessipyWeb.ErrorView)
    |> render(:"401", error: :invalid_login)
  end

  def call(conn, :too_many_attempts) do
    conn
    |> put_status(:too_many_requests)
    |> put_view(RessipyWeb.ErrorView)
    |> render(:"429")
  end

  def call(conn, nil) do
    conn
    |> put_status(:not_found)
    |> put_view(RessipyWeb.ErrorView)
    |> render(:"404")
  end
end
