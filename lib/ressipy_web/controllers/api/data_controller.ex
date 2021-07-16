defmodule RessipyWeb.Api.DataController do
  @moduledoc false

  use RessipyWeb, :controller

  alias Ressipy.Recipes

  action_fallback RessipyWeb.Api.FallbackController

  def index(conn, params) do
    start_time = NaiveDateTime.utc_now()

    with {:ok, filters} <- Recipes.validate_filters(params) do
      assigns = [
        categories: Recipes.list_categories(filters),
        deleted: %{
          categories: [],
          recipes: []
        },
        fetched_at: start_time,
        recipes: Recipes.list_recipes(filters)
      ]

      render(conn, "index.json", assigns)
    end
  end
end
